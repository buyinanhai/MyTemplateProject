//
//  TestCenterChooseVC.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/8/10.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit
import DYTemplate.DYButton
import MJRefresh



enum TestCenterChooseType :Int {
    ///选择类型
    case type = 0
    ///选择学段
    case level = 1
    ///选择学科
    case subject = 2
    ///选择年级
    case grade = 3
    ///选择版本
    case version = 4
    ///选择册别
    case volume = 5
    
}

class TestCenterChooseVC: UIViewController {

    
    private var localModel: TestCenterLocalChooseModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        if let dict = TestCenterChooseVC.getLocalData() {
            self.localModel = TestCenterLocalChooseModel.init(JSON: dict);
            self.currentTypeId = self.localModel?.chooseOption?["0"] ?? 0;
        }
        self.setupSubview()
        // Do any additional setup after loading the view.
    }
    
    
    private func setupSubview() {
        
        self.view.addSubview(self.confirmBtn);
        self.confirmBtn.mas_makeConstraints { (make) in
            make?.bottom.offset()(-20);
            make?.centerX.offset();
            make?.width.offset()(165);
            make?.height.offset()(40);
            
        }
        self.confirmBtn.addTarget(self, action: #selector(confirmBtnClick), for: .touchUpInside);
        
        self.navigationItem.title = "智能出题"
        self.view.backgroundColor = .init(hexString: "#F7F7F7");
        self.view.addSubview(self.collectionView);
        self.collectionView.mas_makeConstraints { (make) in
            make?.left.offset()(15);
            make?.top.offset()(20);
            make?.right.offset()(-15);
            make?.bottom.equalTo()(self.confirmBtn.mas_top)?.offset()(-20);
        }
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        
        self.collectionView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData));
        
        self.collectionView.mj_header?.beginRefreshing();
        
        let array:[[String: Any]] = [["id":0,"name":"知识点出题"],["id":1,"name":"章节出题"]]
        
        var models:[TestCenterChooseModel] = [];
        for (index,item) in array.enumerated() {
            
            let model = TestCenterChooseModel.init(id: item["id"] as! Int, name: item["name"] as! String,index: IndexPath.init(item: index, section: 0));
            models.append(model);
            self.mapLocalSelectModel(arrayIndex: index, selectIndex: 0, model: model);
        }
        self.dataSource[0] = models;
      
        
    }
    
    /**
     反显选中的数据， 并返回下一个请求中需要的id
     */
    private func mapLocalSelectModel(arrayIndex: Int,selectIndex: Int, model: TestCenterChooseModel) -> Int? {
        
        var id: Int?
        //如果当前正在选择 直接默认选中第一个
        if self.isSynchronization {
            if arrayIndex == 0 {
                model.isSelected = true;
                self.selectModel[selectIndex] = model;
                if selectIndex == 3 {
                    if let stageId = model.extra?["stageId"] as? Int {
                        id = stageId;
                    }
                } else {
                    id = model.id;
                }
            }
        } else if let selectId = self.localModel?.chooseOption?["\(selectIndex)"] {
            if selectId == model.id {
                model.isSelected = true;
                self.selectModel[selectIndex] = model;
                if selectIndex == 3 {
                    if let stageId = model.extra?["stageId"] as? Int {
                        id = stageId;
                    }
                } else {
                    id = model.id;
                }
            }
        } else {
            if arrayIndex == 0 {
                model.isSelected = true;
                self.selectModel[selectIndex] = model;
                if selectIndex == 3 {
                    if let stageId = model.extra?["stageId"] as? Int {
                        id = stageId;
                    }
                } else {
                    id = model.id;
                }
            }
        }
        return id;
        
    }
   
    //MARK: network
    @objc
    private func loadData() {
       
        var count = 0;
       
        TestCenterNetwork.getStudyLevel().dy_startRequest { (response, error) in
            
            count += 1;

            if let _response = response as? [[String : Any]] {
                
                //"stageId":"1","name":"小学"
                self.selectModel.removeValue(forKey: TestCenterChooseType.level.rawValue);

                var models:[TestCenterChooseModel] = [];
                for (index,item) in _response.enumerated() {
                    
                    if let id = item["stageId"] as? String, let name = item["name"] as? String {
                        let model = TestCenterChooseModel.init(id: Int(id) ?? 0, name: name,index: IndexPath.init(item: index, section: 1));
                        models.append(model);
                        
                        if let id = self.mapLocalSelectModel(arrayIndex: index, selectIndex: 1, model: model) {
                            self.loadGrades(stageId: id);
                        }
                    }
                }
                self.dataSource[1] = models;
                self.collectionView.reloadSections(IndexSet.init(integer: 1));
            } else {
                
                DYNetworkHUD.showInfo(message: "加载数据失败！", inView: nil);
            }
            if count == 1 {
                self.collectionView.mj_header?.endRefreshing();
            }
        }
    }
    
    private func loadGrades(stageId: Int) {
        
        DYNetworkHUD.startLoading();
        TestCenterNetwork.getGrades(stageId: stageId).dy_startRequest { (response, error) in
            if let _response = response as? [[String : Any]] {
                
                DYNetworkHUD.dismiss()
                self.selectModel.removeValue(forKey: TestCenterChooseType.grade.rawValue);

                //{"id":1,"name":"一年级","stageId":1}
                var models:[TestCenterChooseModel] = [];
                for (index,item) in _response.enumerated() {
                    
                    if let id = item["id"] as? Int, let name = item["name"] as? String {
                        let model = TestCenterChooseModel.init(id: id, name: name,index: IndexPath.init(item: index, section: 3));
                        model.extra = [:];
                        model.extra?["stageId"] = item["stageId"];
                        //先默认小学  假定小学的stageid永远是1
                        models.append(model);
                        
                        if let id = self.mapLocalSelectModel(arrayIndex: index, selectIndex: 3, model: model) {
                            self.loadSubjects(id);
                        }
                    }
                }
                self.dataSource[3] = models.filter({ (model) -> Bool in
                    return (model.extra?["stageId"] as? Int ?? 0 == self.selectModel[1]?.id) && self.currentTypeId == 0;
                });
                self.knowledgeData[3] = models;
                self.collectionView.reloadSections(IndexSet.init(integer: 3));
                
            } else {
                
                DYNetworkHUD.showInfo(message: "加载数据失败！", inView: nil);
            }
           
        }
        
    }
    
    private func loadSubjects(_ stageId: Int) {
        
        DYNetworkHUD.startLoading();
        TestCenterNetwork.getStudySubjects(stageId: stageId).dy_startRequest { (response, error) in
            
            if let _response = response as? [[String : Any]] {
                
                //"subjectId":"1","name":"小学"
                DYNetworkHUD.dismiss();
                self.selectModel.removeValue(forKey: TestCenterChooseType.subject.rawValue);
                var models:[TestCenterChooseModel] = [];
                for (index,item) in _response.enumerated() {
                    
                    if let id = item["subjectId"] as? String, let name = item["subjectName"] as? String {
                        let model = TestCenterChooseModel.init(id: Int(id) ?? 0, name: name, index: IndexPath.init(item: index, section: 2));
                        models.append(model);
                        
                        if let id = self.mapLocalSelectModel(arrayIndex: index, selectIndex: 2, model: model) {
                            self.loadVerson(from: id);

                        }
                    }
                }
                self.dataSource[2] = models;
                self.collectionView.reloadSections(IndexSet.init(integer: 2));
                self.isSynchronization = true;
            } else {
                
                DYNetworkHUD.showInfo(message: "加载数据失败！", inView: nil);
            }
            
            self.collectionView.mj_header?.endRefreshing();
            
        }
        
    }
    
    private func loadVerson(from subjectId: Int) {
        
        DYNetworkHUD.startLoading();

        TestCenterNetwork.getVersions(subjectid: subjectId).dy_startRequest { (response, error) in
            
            if let _response = response as? [[String : Any]] {
                DYNetworkHUD.dismiss();
                //"versionId":"18801","versionName":"湖南版"
                var models:[TestCenterChooseModel] = [];
                self.selectModel.removeValue(forKey: TestCenterChooseType.version.rawValue);
                for (index,item) in _response.enumerated() {
                    
                    if let id = item["versionId"] as? String, let name = item["versionName"] as? String {
                        let model = TestCenterChooseModel.init(id: Int(id) ?? 0, name: name,index: IndexPath.init(item: index, section: 4));
                        models.append(model);
                        
                        if let id = self.mapLocalSelectModel(arrayIndex: index, selectIndex: 4, model: model) {
                            self.loadVolume(id);
                        }
                    }
                }
                self.chapterData[4] = models;
                if self.currentTypeId == 1 {
                    self.dataSource[4] = models;
                }
                self.collectionView.reloadSections(IndexSet.init(integer: 4));
            } else {
                
                DYNetworkHUD.showInfo(message: "加载数据失败！", inView: nil);
            }
           
        }
        
    }
    
    private func loadVolume(_ versionId: Int) {
        DYNetworkHUD.startLoading();

        TestCenterNetwork.getVolume(versionId: versionId).dy_startRequest { (response, error) in
            
            if let _response = response as? [[String : Any]] {
                
                //"subjectId":"1","name":"小学"
                DYNetworkHUD.dismiss();
                self.selectModel.removeValue(forKey: TestCenterChooseType.volume.rawValue);
                var models:[TestCenterChooseModel] = [];
                for (index,item) in _response.enumerated() {
                    
                    if let id = item["bookId"] as? String, let name = item["bookName"] as? String {
                        let model = TestCenterChooseModel.init(id: Int(id) ?? 0, name: name,index: IndexPath.init(item: index, section: 0));
                        models.append(model);
                        self.mapLocalSelectModel(arrayIndex: index, selectIndex: TestCenterChooseType.volume.rawValue, model: model)
                    }
                }
                self.chapterData[TestCenterChooseType.volume.rawValue] = models;
                if self.selectModel[TestCenterChooseType.type.rawValue]?.id ?? -1 == 1 {
                    self.dataSource[TestCenterChooseType.volume.rawValue] = models;
                }
                self.collectionView.reloadSections([TestCenterChooseType.volume.rawValue]);
            } else {
                
                DYNetworkHUD.showInfo(message: "加载数据失败！", inView: nil);
            }
            
            self.collectionView.mj_header?.endRefreshing();
            
        }
        
    }
    
    //MARK:  lazy & properties
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout.init();
        layout.scrollDirection = .vertical;
        
        let view = UICollectionView.init(frame: .zero, collectionViewLayout: layout);
        view.addRound(10);
        view.backgroundColor = .white;
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell");
        view.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        return view;
    }()
    
    /**
     每组只能选择一个
     */
    private var selectModel: [Int: TestCenterChooseModel] = [:];
    private var selectButton: [Int: DYButton] = [:];
    
    private var dataSource: [Int : [TestCenterChooseModel]] = [:];
    
    /**
     为了区分两种不同的显示
     */
    private var knowledgeData:[Int : [TestCenterChooseModel]] = [:];
    private var chapterData:[Int : [TestCenterChooseModel]] = [:];

    private var titles:[String] = ["选择类型","选择学段","选择学科","选择年级","选择版本","选择册别"];
    private var currentTypeId:Int = 0;
    
    /**
     是否同步本地数据完成
     */
    private var isSynchronization: Bool = false;
    
    private lazy var confirmBtn: UIButton = {
        
        let view = UIButton.init();
        
        view.setTitle("立即刷题", for: .normal);
        view.setTitleColor(.white, for: .normal);
        view.titleLabel?.font = .systemFont(ofSize: 15);
        view.addRound(20);
        view.backgroundColor = .init(hexString: "#F9A153");
        return view;
    }()
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


//MARK: actions
extension TestCenterChooseVC {
    
    
    @objc
    private func confirmBtnClick() {
        
      
        var subjectId = -1;
        var volumeId = -1;
        var headerTitle = "";
        var subjectTitle = "";
        let gradeId = self.selectModel[TestCenterChooseType.grade.rawValue]?.id;
               
        if self.selectModel[TestCenterChooseType.type.rawValue]?.id == 0 {
            subjectId =  self.selectModel[TestCenterChooseType.subject.rawValue]?.id ?? -1;
            subjectTitle = String.init(format: "%@-%@",self.selectModel[TestCenterChooseType.level.rawValue]?.name ?? "",self.selectModel[TestCenterChooseType.subject.rawValue]?.name ?? "" )
            headerTitle = "  知识点做题  ";
            if subjectId < 0 {
                DYNetworkHUD.showInfo(message: "请选择科目！", inView: nil);
                return
            }
        } else if self.selectModel[TestCenterChooseType.type.rawValue]?.id == 1 {
            volumeId = self.selectModel[TestCenterChooseType.volume.rawValue]?.id ?? -1;
            subjectTitle = String.init(format: "%@-%@-%@-%@",self.selectModel[TestCenterChooseType.level.rawValue]?.name ?? "",self.selectModel[TestCenterChooseType.subject.rawValue]?.name ?? "",self.selectModel[TestCenterChooseType.version.rawValue]?.name ?? "",self.selectModel[TestCenterChooseType.volume.rawValue]?.name ?? "" );
            headerTitle = "  章节做题  ";
            if volumeId < 0 {
                DYNetworkHUD.showInfo(message: "请选择册别！", inView: nil);
                return
            }
        }
       
        if (self.navigationController?.viewControllers.count ?? 0) > 2 {
            let lastVC = self.navigationController?.viewControllers[1] as? TestCenterHomeVC;
            lastVC?.subjectId = subjectId;
            lastVC?.subjectTitle = subjectTitle;
            lastVC?.volumeId = volumeId;
            lastVC?.headerTitle = headerTitle;
            lastVC?.gradeId = gradeId;
            lastVC?.update();
            self.navigationController?.popViewController(animated: true);
        } else {
            let vc = TestCenterHomeVC.init();
            vc.chooseVC = self;
            vc.subjectTitle = subjectTitle;
            vc.subjectId = subjectId;
            vc.volumeId = volumeId;
            vc.headerTitle = headerTitle;
            vc.gradeId = gradeId;
            self.navigationController?.pushViewController(vc, animated: true);
            self.navigationController?.viewControllers.remove(at: 1);
        }
        var option: [String: Int] = [:]
        for index in self.selectModel.keys {
            let model = self.selectModel[index];
            if let id = model?.id {
                option["\(index)"] = id;
            }
        }
        let dict = ["subjectTitle":subjectTitle,"subjectId":subjectId,"volumeId":volumeId,"headerTitle":headerTitle,"chooseOption": option,"gradeId": gradeId ?? -1
            ] as [String : Any];
        TestCenterChooseVC.updateLocalData(dict);
    }
    
    
    private class func updateLocalData(_ dict: [String:Any]) {
       
        if let data = try? JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed) {
            UserDefaults.standard.setValue(data, forKey: "xyw-tesetCenter-choose-data");
        }
        
    }
    public class func getLocalData() -> [String : Any]? {
        
        if let data = UserDefaults.standard.value(forKey: "xyw-tesetCenter-choose-data") as? Data {
            if let dict = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) {
                return dict as? [String : Any];
            }
        }
        return nil;
    }
    
}

extension TestCenterChooseVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.titles.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource[section]?.count ?? 0;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt
        indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath);
        var btn:DYButton? = cell.contentView.subviews.first as? DYButton;
        if btn == nil {
            btn = DYButton.init();
            btn?.addRound(14);
            cell.contentView.addSubview(btn!);
            btn?.mas_makeConstraints { (make) in
                make?.edges.offset();
            }
            btn?.dy_setBackgroundColor(UIColor.init(hexString: "#E9E9E9"), for: UIControl.State.normal);
            btn?.dy_setBackgroundColor(UIColor.init(hexString: "#FFF5E9"), for: .selected);
            btn?.textColor = .init(hexString: "#555555");
            btn?.seleTextColor = .init(hexString: "#FDA236");
            btn?.dy_setBorderColor(.init(hexString: "#FDA337"), for: .selected);
            btn?.dy_setBorderColor(.clear, for: .normal);
            btn?.layer.borderWidth = 1.0;
            btn?.addTarget(self, action: #selector(btnClick(_ :)), for: .touchUpInside);
            btn?.titleLabel?.font = .systemFont(ofSize: 12);
        
        }
        btn?.indexpath = indexPath;
        if let model = self.dataSource[indexPath.section]?[indexPath.row] {
            btn?.setTitle(model.name, for: .normal);
            btn?.isSelected = model.isSelected;
            if model.isSelected {
                self.selectButton[indexPath.section] = btn;
            }
        }
        
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath);

        var label: UILabel? = header.subviews.first as? UILabel;
        if label == nil {
            label = UILabel.init();
            label?.font = .boldSystemFont(ofSize: 15);
            label?.textColor = .black;
            header.addSubview(label!);
            label?.mas_makeConstraints({ (make) in
                make?.left.offset()(14);
                make?.centerY.offset();
            })
        }
        label?.text = self.titles[indexPath.section];
        
        
        return header;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if self.dataSource[section]?.count ?? 0 > 0 {
            return CGSize.init(width: 120, height: 44);
        }
        return .zero;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .init(width: 84, height: 28);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return .init(top: 0, left: 14, bottom: 0, right: 14);
    }
    
    
    
    @objc
    private func btnClick(_ sender: DYButton) {

        if sender.isSelected {
            return;
        }
       
        if let currentModel = self.dataSource[sender.indexpath.section]?[sender.indexpath.item] {
           
            let section = sender.indexpath.section;
            currentModel.isSelected = true;
            let lastModel = self.selectModel[section];
            lastModel?.isSelected = false;
            self.selectModel[section] = currentModel;
            
            if let lastIndexPath = self.selectButton[sender.indexpath.section]?.indexpath {
                self.collectionView.reloadItems(at: [sender.indexpath, lastIndexPath]);
            }
            self.handlerSectionUpdate(sender.indexpath);
            
        }
        
        
    }
    /**
     处理各组的联动更新
     */
    private func handlerSectionUpdate(_ indexPath: IndexPath) {
        
        let currentModel = self.dataSource[indexPath.section]?[indexPath.item];
        let type = TestCenterChooseType.init(rawValue: indexPath.section);
        
        if type == .type && indexPath.item == 0 {
            //点击了知识点出题
            self.currentTypeId = 0;
            self.dataSource.removeValue(forKey: TestCenterChooseType.volume.rawValue);
            self.dataSource.removeValue(forKey: TestCenterChooseType.version.rawValue);
            self.dataSource.updateValue(self.knowledgeData[TestCenterChooseType.grade.rawValue] ?? [], forKey: TestCenterChooseType.grade.rawValue);
//            for item in self.knowledgeData {
//                //过滤年级
//                let value = item.value.filter { (model) -> Bool in
//                    return model.extra?["stageId"] as? Int ?? 0 == self.selectModel[TestCenterChooseType.level.rawValue]?.id ?? 0;
//                }
//                if let defaultModel = value.first {
//                    defaultModel.isSelected = true;
//                    self.selectModel[TestCenterChooseType.level.rawValue]?.isSelected = false;
//                    self.selectModel[TestCenterChooseType.level.rawValue] = defaultModel;
//                }
//                self.dataSource.updateValue(value, forKey: item.key);
//            }
            self.collectionView.reloadData()
        } else if type == .type  && indexPath.item == 1 {
            //点击了章节出题
            self.currentTypeId = 1;
            for item in self.chapterData {
                self.dataSource.updateValue(item.value, forKey: item.key);
            }
            self.dataSource.removeValue(forKey: 3);
            self.collectionView.reloadData()
        } else if type == .level {
            
            self.loadGrades(stageId: currentModel?.id ?? -1);
//            if let typeModel = self.selectModel[0] {

//                if typeModel.id == 0 {
                    //还要联动年级组
//                    let grade = TestCenterChooseType.grade.rawValue;
//                    self.dataSource[grade] = self.knowledgeData[grade]?.filter({ (model) -> Bool in
//                        return model.extra?["stageId"] as? Int ?? 0 == currentModel?.id;
//                    });
//                    if let defaultModel = self.dataSource[3]?.first {
//                        defaultModel.isSelected = true;
//                        self.selectModel[grade]?.isSelected = false;
//                        self.selectModel[grade] = defaultModel;
//                    }
//                    self.collectionView.reloadSections([grade]);
//                }
//                self.loadSubjects(currentModel?.id ?? 0);
//            }
        } else if type == .version {
            
            self.loadVolume(currentModel?.id ?? 0);
            
        } else if type == .grade {
            
            self.loadSubjects(currentModel?.extra?["stageId"] as? Int ?? 0);
        } else if type  == .subject {
            
            self.loadVerson(from: currentModel?.id ?? 0);
        }
    }
    
    
}


private class TestCenterChooseModel {
    
    let id: Int
    let name: String
    
    var isSelected: Bool = false;
    
    var extra:[String:Any]?
    
    var index: IndexPath
    
    init(id: Int, name: String, index: IndexPath) {
        self.id = id;
        self.name = name;
        self.index = index;
    }
    
    
}
