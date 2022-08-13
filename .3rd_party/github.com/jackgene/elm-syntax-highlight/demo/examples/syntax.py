from enum import Enum
from typing import *

# Comment
PI: float = 3.14
num: Optional[int] = None
nums: list[int] = [1, 2, 3]
flag: bool = True
iceCream: str = "chocolate" if flag else "vanilla"

if iceCream == 'chocolate':
    print(f'Yay, I love ${iceCream} ice cream!')
else:
    print('Awwww, but chocolate is my favorite...')


def multiply(num1: float, num2: float) -> float:
    result = num1 * num2 * 1.0
    return result


product: float = multiply(num, 10)


class Thing:
    pass


class Polygon(Thing):
    _name: str
    _height: float
    _width: float

    def __init__(self, height: float, width: float):
        super()
        self._name = 'Polygon'
        self._height = height
        self._width = width

    @staticmethod
    def get_name(self) -> str:
        print("hello")
        x = 1 * 2
        return self._name


def make_polygon(height: float) -> Polygon:
    return Polygon(height, product)


p: Polygon = make_polygon(1.4)
p.get_name()


class Direction(Enum):
    NORTH = "n"
    SOUTH = "s"
    EAST = "e"
    WEST = "w"


print(Direction.NORTH)
