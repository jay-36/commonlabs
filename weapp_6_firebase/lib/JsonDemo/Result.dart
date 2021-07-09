
import 'package:weapp_6_firebase/JsonDemo/Genre.dart';

class Result {
    String artistId;
    String artistName;
    String artistUrl;
    String artworkUrl100;
    String contentAdvisoryRating;
    String copyright;
    List<Genre> genres;
    String id;
    String kind;
    String name;
    String releaseDate;
    String url;

    Result({this.artistId, this.artistName, this.artistUrl, this.artworkUrl100, this.contentAdvisoryRating, this.copyright, this.genres, this.id, this.kind, this.name, this.releaseDate, this.url});

    factory Result.fromJson(Map<String, dynamic> json) {
        return Result(
            artistId: json['artistId'], 
            artistName: json['artistName'], 
            artistUrl: json['artistUrl'], 
            artworkUrl100: json['artworkUrl100'], 
            contentAdvisoryRating: json['contentAdvisoryRating'], 
            copyright: json['copyright'], 
            genres: json['genres'] != null ? (json['genres'] as List).map((i) => Genre.fromJson(i)).toList() : null, 
            id: json['id'], 
            kind: json['kind'], 
            name: json['name'], 
            releaseDate: json['releaseDate'], 
            url: json['url'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['artistId'] = this.artistId;
        data['artistName'] = this.artistName;
        data['artistUrl'] = this.artistUrl;
        data['artworkUrl100'] = this.artworkUrl100;
        data['contentAdvisoryRating'] = this.contentAdvisoryRating;
        data['copyright'] = this.copyright;
        data['id'] = this.id;
        data['kind'] = this.kind;
        data['name'] = this.name;
        data['releaseDate'] = this.releaseDate;
        data['url'] = this.url;
        if (this.genres != null) {
            data['genres'] = this.genres.map((v) => v.toJson()).toList();
        }
        return data;
    }
}