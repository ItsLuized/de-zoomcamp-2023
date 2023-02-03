from prefect.filesystems import GitHub

github_block = GitHub(
    repository="https://github.com/ItsLuized/de-zoomcamp-2023")

github_block.get_directory("week2/flows")
github_block.save("github-storage-hw4", overwrite=True)
