from typing import Any, List, Optional
import insightface

import modules.globals
from modules.typing import Frame,Face

FACE_ANALYSER = None


def get_face_analyser() -> Any:
    global FACE_ANALYSER
    if FACE_ANALYSER is None:
        initialize_face_analyser()
    return FACE_ANALYSER




def _safe_get(frame: Frame, **kwargs) -> List[Face]:
    """Runs detection without crashing on an empty frame or a detector error."""
    if frame is None or getattr(frame, 'size', 0) == 0:
        return []
    try:
        return get_face_analyser().get(frame, **kwargs) or []
    except Exception as e:
        print(f'[FACE_ANALYSER] Error detectando caras: {e}')
        return []


def get_one_face(frame: Frame) -> Optional[Face]:
    faces = _safe_get(frame, max_num=1)
    return faces[0] if faces else None





def get_many_faces(frame: Frame) -> List[Face]:
    return _safe_get(frame)










def initialize_face_analyser():
    global FACE_ANALYSER
    if FACE_ANALYSER is None:
        FACE_ANALYSER = insightface.app.FaceAnalysis(name='buffalo_l', providers=modules.globals.execution_providers)
        FACE_ANALYSER.prepare(ctx_id=0, det_size=(640, 640))

def get_one_face_left(frame: Frame) -> Optional[Face]:
    faces = _safe_get(frame)
    return min(faces, key=lambda x: x.bbox[0]) if faces else None

def get_one_face_right(frame: Frame) -> Optional[Face]:
    faces = _safe_get(frame)
    return max(faces, key=lambda x: x.bbox[0]) if faces else None

def get_two_faces(frame: Frame) -> List[Face]:
    faces = _safe_get(frame, max_num=2)
    return sorted(faces, key=lambda x: x.bbox[0])