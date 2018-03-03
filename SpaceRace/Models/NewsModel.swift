//
//  NewsModel.swift
//
//
//  Created by Dalton Ng on 13/2/18.
//  Copyright © 2018 AppsLab. All rights reserved.
//

class NewsModel {
    
    var title: String?
    var description: String?
    var link: String?
    var thumbnail: String?
    var pubDate: String?
    var id: String?
    
    init(title: String?, description: String?, link: String?, thumbnail: String?, pubDate: String?, id: String?){
        self.title = title
        self.description = description
        self.link = link
        self.thumbnail = thumbnail
        self.pubDate = pubDate
        self.id = id
    }
}
