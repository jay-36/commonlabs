
import 'package:weapp_6_firebase/JsonDemo/Feed.dart';

class Saturday {
    Feed feed;

    Saturday({this.feed});

    factory Saturday.fromJson(Map<String, dynamic> json) {
        return Saturday(
            feed: json['feed'] != null ? Feed.fromJson(json['feed']) : null, 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        if (this.feed != null) {
            data['feed'] = this.feed.toJson();
        }
        return data;
    }
}