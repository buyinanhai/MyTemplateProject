//
//  YZDTestResultCell.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/7/15.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit

/**
 答题结果cell
 */
class YZDTestResultCell: DYTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.setupSubview();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubview() {
        self.backgroundColor = .clear
        let subContentView = UIView.init(frame: .zero);
        self.contentView.addSubview(subContentView);
        subContentView.mas_makeConstraints { (make) in
            make?.edges.offset();
        }
        
        subContentView.addSubview(self.webView);
        self.webView.mas_makeConstraints { (make) in
            make?.left.right()?.top()?.offset();
            make?.bottom.offset()(-5);
        }
        
    }
    
    
    private lazy var webView: WKWebView = {
        
        let html = "<h1>第1行</h1><br/><h1>第2行</h1><br/><h1>第3行</h1><br/><h1>第4行</h1><br/><h1>第5行</h1><br/><h1>第6行</h1><br/><h1>第7行</h1><br/>"
        let view = WKWebView.init();
        view.loadHTMLString(html, baseURL: nil);
        view.scrollView.isScrollEnabled = false;
        
        return view;
    }()
}
