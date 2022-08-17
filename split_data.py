import pickle
import os
import shutil
import pandas as pd
import numpy as np


with open("/Users/cin/Documents/data_sort.pickle", "rb") as fp:
    data = pickle.load(fp)

im_names = data["ims"]
pred_labels = data["preds"]
out_dir = "/Users/cin/Documents/sort_fungi_v1"

data_csv_path = "/Users/cin/Documents/data_with_labels.csv"
df = pd.read_csv(data_csv_path, delimiter=",")
df["image"] = df["image"].str.replace("/data/AIDatasets/fungi/DF20M/", "")


if not os.path.isdir(out_dir):
    os.mkdir(out_dir)
    for i in range(183):
        os.mkdir(os.path.join(out_dir, str(i)))

for im_name, label in zip(im_names, pred_labels):
    label = f"{label}"
    if im_name in df.values[:, 0]:
        label = f"{ df.values[np.where(im_name == df.values[:, 0])[0][0], 1]}"
        shutil.copyfile(os.path.join("/Users/cin/Documents/", "DF20M", im_name), os.path.join(out_dir, f"{label}", "0__" + im_name))
    else:
        shutil.copyfile(os.path.join("/Users/cin/Documents/", "DF20M", im_name), os.path.join(out_dir, f"{label}", im_name))
