import torch
import deep_ep_cpp

from .utils import EventOverlap
from .buffer import Buffer

# noinspection PyUnresolvedReferences
from deep_ep_cpp import Config

# Set topk_idx_t based on backend
if hasattr(deep_ep_cpp, 'topk_idx_t'):
    topk_idx_t = deep_ep_cpp.topk_idx_t
else:
    # For XPU or other backends, use torch.int64
    topk_idx_t = torch.int64
