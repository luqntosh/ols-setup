package main

import "core:fmt"
import "core:os"

ols :: `{
	"$schema": "https://raw.githubusercontent.com/DanielGavin/ols/master/misc/ols.schema.json",
	"collections": [],
	"enable_semantic_tokens": false,
	"enable_document_symbols": true,
	"enable_hover": true,
	"enable_snippets": true,
}`

odinfmt :: `{
  "character_width": 100,
  "tabs": true,
  "tabs_width": 4,
  "spaces": 2
}`


main :: proc() {
	create_ols := create_settings("./ols.json")
	if create_ols {
		write_to_file("ols.json", ols)
	}
	create_odinfmt := create_settings("./odinfmt.json")
	if create_odinfmt {
		write_to_file("odinfmt.json", odinfmt)
	}
}


write_to_file :: proc(file_name: string, content: string) {
	f, err := os.open(file_name, os.O_WRONLY | os.O_CREATE, 0o644)
	defer os.close(f)
	if err != 0 {
		fmt.printf("Could not open %s file.\n", file_name)
		return
	}
	_, err = os.write_string(f, content)
	if err != 0 {
		fmt.printf("Can not write to %s.\n", file_name)
		return
	}
}

create_settings :: proc(file_name: string) -> bool {
	if os.exists(file_name) {
		buf: [32]byte
		for {
			fmt.printf("%s already exists. Do you want to overrite it? y/n\n", file_name)
			n, _ := os.read(os.stdin, buf[:])
			if n == 2 {
				switch buf[0] {
				case 'n', 'N':
					return false
				case 'y', 'Y':
					return true
				}
			}
		}
	}
	return true
}
