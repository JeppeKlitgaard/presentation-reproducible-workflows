import qim3d

downloader = qim3d.io.Downloader()
data = downloader.load_dataset("kiwi", format="zarr", output_dir="data")