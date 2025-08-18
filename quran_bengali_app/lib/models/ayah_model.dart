class Ayah {
  final int number;
  final String text;
  final int numberInSurah;
  final int? page;
  final int? surahNumber;
  final int? juz;
  final String? bengaliText;

  Ayah({
    required this.number,
    required this.text,
    required this.numberInSurah,
    this.page,
    this.surahNumber,
    this.juz,
    this.bengaliText,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      number: json['number'],
      text: json['text'],
      numberInSurah: json['numberInSurah'],
      page: json['page'],
      surahNumber: json['surahNumber'],
      juz: json['juz'],
      bengaliText: json['bengaliText'],
    );
  }

  Map<String, dynamic> toJson() => {
    'number': number,
    'text': text,
    'numberInSurah': numberInSurah,
    'page': page,
    'surahNumber': surahNumber,
    'juz': juz,
    'bengaliText': bengaliText,
  };
}