//
//  ViewController.swift
//  TesterList
//
//  Created by Jonny on 7/29/17.
//  Copyright © 2017 Jonny. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    private var emails = [String]()

    @IBAction private func openDocument(_ sender: Any) {

        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true

        let type: String
        if #available(OSX 10.10, *) {
            type = kUTTypeCommaSeparatedText as String // csv file
        } else {
            type = kUTTypeText as String
        }
        panel.allowedFileTypes = [type]

        panel.beginSheetModal(for: view.window!) { result in
            guard result == .OK else { return }
            DispatchQueue.main.async {
                self.handleTextFileURLs(panel.urls)
            }
        }
    }

    override func responds(to aSelector: Selector!) -> Bool {
        if emails.isEmpty, (aSelector == #selector(saveDocument) || aSelector == #selector(saveDocumentAs)) {
            return false
        }
        return super.responds(to: aSelector)
    }

    @IBAction private func saveDocument(_ sender: Any) {
        saveDocumentAs(sender)
    }

    @IBAction private func saveDocumentAs(_ sender: Any) {
        let panel = NSSavePanel()
        panel.canCreateDirectories = true
        panel.nameFieldStringValue = "Testers.csv"
        panel.beginSheetModal(for: view.window!) { result in
            guard let url = panel.url else { return }
            DispatchQueue.main.async {
                self.save(self.emails, to: url)
            }
        }
    }

    private func handleTextFileURLs(_ urls: [URL]) {
        do {
            var emails = [String]()
            for url in urls {
                var string = try String(contentsOf: url)
                string = string.replacingOccurrences(of: "\"", with: "")
                string = string.replacingOccurrences(of: "\n", with: ",")

                for substring in string.split(separator: ",") where substring.contains("@") {
                    emails.append("\(substring)")
                }
            }
            self.emails = emails
            saveDocumentAs(self)
        } catch {
            print(error)
            presentError(error)
        }
    }

    private func save(_ emails: [String], to fileURL: URL) {
        guard !emails.isEmpty else { return }

        var string = ""
        for email in emails {
            string += "\"N\",\"A\",\"\(email)\"\n"
        }

        do {
            try string.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print(error)
            presentError(error)
        }
    }

}

