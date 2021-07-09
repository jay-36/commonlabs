
import 'package:weapp_6_firebase/JsonDemo/Author.dart';
import 'package:weapp_6_firebase/JsonDemo/Link.dart';
import 'package:weapp_6_firebase/JsonDemo/Result.dart';

class Feed {
    Author author;
    String copyright;
    String country;
    String icon;
    String id;
    List<Link> links;
    List<Result> results;
    String title;
    String updated;

    Feed({this.author, this.copyright, this.country, this.icon, this.id, this.links, this.results, this.title, this.updated});

    factory Feed.fromJson(Map<String, dynamic> json) {
        return Feed(
            author: json['author'] != null ? Author.fromJson(json['author']) : null, 
            copyright: json['copyright'], 
            country: json['country'], 
            icon: json['icon'], 
            id: json['id'], 
            links: json['links'] != null ? (json['links'] as List).map((i) => Link.fromJson(i)).toList() : null, 
            results: json['results'] != null ? (json['results'] as List).map((i) => Result.fromJson(i)).toList() : null, 
            title: json['title'], 
            updated: json['updated'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['copyright'] = this.copyright;
        data['country'] = this.country;
        data['icon'] = this.icon;
        data['id'] = this.id;
        data['title'] = this.title;
        data['updated'] = this.updated;
        if (this.author != null) {
            data['author'] = this.author.toJson();
        }
        if (this.links != null) {
            data['links'] = this.links.map((v) => v.toJson()).toList();
        }
        if (this.results != null) {
            data['results'] = this.results.map((v) => v.toJson()).toList();
        }
        return data;
    }
}