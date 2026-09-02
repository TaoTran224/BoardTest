import configparser
import os

from analyze import TextAnalyzer


def load_config():

    config = configparser.ConfigParser()

    config.read("config.ini", encoding="utf-8")

    input_folder = config["PATH"]["input_folder"]
    output_file = config["PATH"]["output_file"]

    search_string = config["SEARCH"]["search_string"]

    file_extension = config["OPTIONS"].get(
        "file_extension",
        ".txt"
    )

    recursive = config["OPTIONS"].getboolean(
        "recursive",
        fallback=False
    )

    encoding = config["OPTIONS"].get(
        "encoding",
        "utf-8"
    )

    case_sensitive = config["OPTIONS"].getboolean(
        "case_sensitive",
        fallback=True
    )

    return {
        "input_folder": input_folder,
        "output_file": output_file,
        "search_string": search_string,
        "file_extension": file_extension,
        "recursive": recursive,
        "encoding": encoding,
        "case_sensitive": case_sensitive
    }


def save_results(results, output_file, search_string):

    output_folder = os.path.dirname(output_file)

    if output_folder:
        os.makedirs(output_folder, exist_ok=True)

    total_count = 0

    with open(output_file, "w", encoding="utf-8") as file:

        file.write("TEXT ANALYSIS RESULT\n")
        file.write("=" * 60 + "\n")
        file.write(f"Search string: {search_string}\n\n")

        for result in results:

            file.write(f"File: {result['file']}\n")
            file.write(f"Number of matches: {result['count']}\n")

            total_count += result["count"]

            if result["lines"]:

                file.write("Matched lines:\n")

                for line_number, line in result["lines"]:

                    file.write(
                        f"  Line {line_number}: {line}\n"
                    )

            file.write("-" * 60 + "\n")

        file.write("\n")
        file.write("=" * 60 + "\n")
        file.write(f"TOTAL MATCHES: {total_count}\n")


def main():

    config = load_config()

    input_folder = config["input_folder"]

    if not os.path.isdir(input_folder):

        print("ERROR: Thư mục không tồn tại:")
        print(input_folder)
        return

    print("=" * 60)
    print("TEXT FILE ANALYZER")
    print("=" * 60)

    print(f"Folder : {input_folder}")
    print(f"Search : {config['search_string']}")
    print()

    analyzer = TextAnalyzer(
        search_string=config["search_string"],
        encoding=config["encoding"],
        file_extension=config["file_extension"],
        case_sensitive=config["case_sensitive"]
    )

    results = analyzer.analyze_folder(
        input_folder,
        recursive=config["recursive"]
    )

    save_results(
        results,
        config["output_file"],
        config["search_string"]
    )

    total_files = len(results)
    total_matches = sum(
        result["count"] for result in results
    )

    print(f"Số file phân tích : {total_files}")
    print(f"Số dòng tìm thấy  : {total_matches}")
    print()
    print("Kết quả đã được lưu tại:")
    print(config["output_file"])


if __name__ == "__main__":
    main()