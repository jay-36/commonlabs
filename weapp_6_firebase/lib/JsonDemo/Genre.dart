
class Genre {
    String genreId;
    String name;
    String url;

    Genre({this.genreId, this.name, this.url});

    factory Genre.fromJson(Map<String, dynamic> json) {
        return Genre(
            genreId: json['genreId'], 
            name: json['name'], 
            url: json['url'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['genreId'] = this.genreId;
        data['name'] = this.name;
        data['url'] = this.url;
        return data;
    }
}