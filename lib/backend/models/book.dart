class Book
{
  String title, subtitle, isbn13, price, image, url, authors,
         publisher, language, isbn10, pages, year, rating, desc;
  Book({this.title, this.subtitle, this.isbn13, this.price, this.image, this.url,
      this.authors, this.desc, this.isbn10, this.language, this.pages, this.publisher, this.rating, this.year});

  factory Book.fromJson(dynamic json)
  {
    return Book(
      title: json['title'],
      subtitle: json['subtitle'],
      isbn13: json['isbn13'],
      price: json['price'],
      image: json['image'],
      url: json['url'],
      authors: json['authors'],
      publisher: json['publisher'],
      language: json['language'],
      isbn10: json['isbn10'],
      pages: json['pages'],
      year: json['year'],
      rating: json['rating'],
      desc: json['desc']
    );
  }
}