import cv2
from skimage import image
import argparse
import numpy as np
import torch
from deepcoloring.utils import rgba2rgb, normalize, postprocess, symmetric_best_dice, get_as_list
from skimage import imread

if __name__ == "__main__":
    

