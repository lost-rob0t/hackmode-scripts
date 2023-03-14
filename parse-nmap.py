#!/usr/bin/env python3
import json
import xmltodict
import argparse

"""
Simple xml to json, fuck xml.
"""
def parse(xml):
    with open(xml, "r") as xmlfile:
        xml_content = xmlfile.read()
        jsondata = xmltodict.parse(xml_content)
        return jsondata
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("input", help="input nmap scan xml")
    parser.add_argument("output", help="output json")
    parser.add_argument("--pretty", type=bool, help="pretty print?", default=False)
    args = parser.parse_args()
    with open(args.output, "w") as outfile:
        jsondata = parse(args.input)
        if args.pretty:
            outfile.write(json.dumps(jsondata, indent=4, sort_keys=True))
        else:
            outfile.write(json.dumps(jsondata))
if __name__ == '__main__':
    main()
