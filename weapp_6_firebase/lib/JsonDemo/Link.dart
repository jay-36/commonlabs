
class Link {
    String alternate;
    String self;

    Link({this.alternate, this.self});

    factory Link.fromJson(Map<String, dynamic> json) {
        return Link(
            alternate: json['alternate'], 
            self: json['self'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['alternate'] = this.alternate;
        data['self'] = this.self;
        return data;
    }
}