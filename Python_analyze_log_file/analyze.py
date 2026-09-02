import os


class TextAnalyzer:

    def __init__(self, search_string, encoding="utf-8",
                 file_extension=".txt", case_sensitive=True):

        self.search_string = search_string
        self.encoding = encoding
        self.file_extension = file_extension
        self.case_sensitive = case_sensitive

    def analyze_file(self, file_path):

        count = 0
        matched_lines = []

        try:
            with open(file_path, "r", encoding=self.encoding) as file:

                for line_number, line in enumerate(file, start=1):

                    if self.case_sensitive:
                        found = self.search_string in line
                    else:
                        found = self.search_string.lower() in line.lower()

                    if found:
                        count += 1
                        matched_lines.append(
                            (line_number, line.rstrip())
                        )

        except Exception as e:
            print(f"Lỗi khi đọc file: {file_path}")
            print(f"Chi tiết: {e}")

        return count, matched_lines

    def analyze_folder(self, folder_path, recursive=False):

        results = []

        if recursive:

            for root, dirs, files in os.walk(folder_path):

                for filename in files:

                    if filename.lower().endswith(
                            self.file_extension.lower()):

                        file_path = os.path.join(root, filename)

                        count, matched_lines = self.analyze_file(file_path)

                        results.append({
                            "file": file_path,
                            "count": count,
                            "lines": matched_lines
                        })

        else:

            for filename in os.listdir(folder_path):

                file_path = os.path.join(folder_path, filename)

                if os.path.isfile(file_path):

                    if filename.lower().endswith(
                            self.file_extension.lower()):

                        count, matched_lines = self.analyze_file(file_path)

                        results.append({
                            "file": file_path,
                            "count": count,
                            "lines": matched_lines
                        })

        return results