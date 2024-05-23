# follows CLDR conventions for en/fr/ja/ko/zh + nonstandard "zero" special case
def plural: keys | length > 0 and all(IN("one", "other", "zero"));
