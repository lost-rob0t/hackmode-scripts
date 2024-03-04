import sys
import argparse
from nltk.stem import PorterStemmer
import fileinput


def generate_variations_with_stem(word):
    variations = set()
    # Add the original word
    variations.add(word)
    # Get the stem using Porter Stemmer
    stemmer = PorterStemmer()
    stem = stemmer.stem(word)
    variations.add(stem)
    if len(word) > 3:
        for i in range(1, len(word)):
            variations.add(word[:i])
            variations.add(word[i:])

    return variations


def main():
    parser = argparse.ArgumentParser(description="Generate variations for a word.")
    parser.add_argument(
        "word", nargs="?", help="Word for which variations need to be generated"
    )
    args = parser.parse_args()

    if not sys.stdin.isatty():
        # Read from stdin if data is being piped
        for line in fileinput.input():
            for word in generate_variations_with_stem(line.rstrip()):
                print(word)
    elif args.word:
        # Use the CLI argument if provided
        word = args.word
        variations = set()
        # Generate variations for the whole word
        variations.update(generate_variations_with_stem(word))
        for word in variations:
            print(word)


if __name__ == "__main__":
    main()
