
from collections import deque

maze = [['x', '1', '1'], ['0', '0', '1'], ['1', 'y', '1']]

path_len = 0  # 如果题目没给出终点坐标，就会给路径长度，但记得 len = 题目给的len + 1


def bfs(start, end, barrier):
    directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]  # 方向
    for i in range(len(maze)):
        for j in range(len(maze[i])):
            if maze[i][j] == start:  # 起点 比如为 x
                start = (i, j)
            if maze[i][j] == end:  # 终点 比如为 y
                end = (i, j)

    queue = deque()
    queue.append((start, [start]))  # (当前位置, 路径)
    visited = set()
    visited.add(start)
    while queue:
        position, path = queue.popleft()
        if position == end:
            return path
        elif len(path) == path_len:
            return path
        for d in directions:
            next_position = (position[0] + d[0], position[1] + d[1])
            if 0 <= next_position[0] < len(maze) and 0 <= next_position[1] < len(maze) and \
                    maze[next_position[0]][next_position[1]] != barrier and next_position not in visited:
                queue.append((next_position, path + [next_position]))
                visited.add(next_position)


if __name__ == '__main__':
    maze[0][0] = 'x'    # 手动添加, x位置
    maze[2][1] = 'y'
    path = bfs('x', 'y', '1')   # 手动添加, (起点, 终点, 障碍物)
    print("移动路径坐标:", path)
    print("移动路径方位: ", end='')
    for i in range(1, len(path)):
        x1, x2, y1, y2 = path[i - 1][0], path[i - 1][1], path[i][0], path[i][1]
        if x1 > x2:
            print("w", end='')
        elif x1 < x2:
            print("s", end='')
        elif y1 > y2:
            print("a", end='')
        elif y1 < y2:
            print("d", end='')
