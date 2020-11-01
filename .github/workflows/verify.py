import os
import sys
import re

print ("Verifying files...")

git_tag_version = sys.argv[1]
print(f"Target version: {git_tag_version}")

def verify_toc(target_version):
	with open('JustSpeedRun.toc', 'r') as toc:
		lines = toc.readlines()
		found = False

		for line in lines:
			result = re.fullmatch("## Version: ((\d+.){2}\d+)\s$", line)

			if not result == None:
				toc_vers = result.groups()[0]
				print(f"TOC file version: {toc_vers}")

				if toc_vers == target_version:
					found = True
					break

				if not toc_vers == target_version:
					raise ValueError(f"TOC version should equal {target_version}")
		
		if found == False:
			raise ValueError(f"TOC file should include infos for version {target_version}")


def verify_changelogs(target_version):
	with open('CHANGELOG.md', 'r') as changelogs:
		lines = changelogs.readlines()
		found = False

		for line in lines:
			result = re.fullmatch("## ((\d+.){2}\d+) \(\d{4}(-\d{2}){2}\)\s$", line)

			if not result == None:
				cl_vers = result.groups()[0]

				if cl_vers == target_version:
					found = True
					print(f"Changelogs contains patch-notes for v{target_version}")
					break
		
		if found == False:
			raise ValueError(f"Changelogs file should include infos for version {target_version}")


verify_toc(git_tag_version)
verify_changelogs(git_tag_version)
print("Verifation succeed !")