import os
import xml.etree.ElementTree as ET
import json

# Parse the XML file
def extract_dip_switches(xml_file):
    tree = ET.parse(xml_file)
    root = tree.getroot()

    for machine in root.findall('machine'):
        machine_name = machine.get('name')
        dip_switches = []

        for dipswitch in machine.findall('dipswitch'):
            dip_name = dipswitch.get('name')
            default_value = None
            values = []

            for dipvalue in dipswitch.findall('dipvalue'):
                value_name = dipvalue.get('name')
                values.append(value_name)

                # Check if this is the default value
                if dipvalue.get('default') == 'yes':
                    default_value = len(values) - 1

            dip_switches.append({
                "name": dip_name,
                "default": default_value,
                "values": values
            })

        # Create a JSON file for the machine
        output_filename = f"definitions.auto/{machine_name}.nut"
        with open(output_filename, 'w', encoding='utf-8') as json_file:
            json_file.write("return ")
            json.dump(dip_switches, json_file, indent=2)

# Specify the input XML file
xml_file = "gamelist.xml"  # Replace with the actual XML file path
extract_dip_switches(xml_file)
