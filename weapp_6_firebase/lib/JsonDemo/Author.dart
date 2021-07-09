
class Author {
    String name;
    String uri;

    Author({this.name, this.uri});

    factory Author.fromJson(Map<String, dynamic> json) {
        return Author(
            name: json['name'], 
            uri: json['uri'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['name'] = this.name;
        data['uri'] = this.uri;
        return data;
    }
}