format:
	dart run import_sorter:main
	dart format lib/ test/
check-outdated:
	flutter pub outdated
build-runner:
	dart run build_runner build -d
	dart run import_sorter:main
	dart fix --apply