class Point
  attr_reader :x, :y

  def initialize(x=0, y=0)
    @x, @y = x, y
  end

  def inspect   #用于显示
    "(#{x}, #{y})"
  end

  def +(other)  #将x,y分别进行加法运算
    self.class.new(x + other.x, y + other.y)
  end

  def -(other)  #将x,y分别进行减法运算
    self.class.new(x - other.x, y - other.y)
  end

  def +@
    dup         #返回自己的副本
  end

  def -@
    self.class.new(-x, -y)  #颠倒xy各自的正负
  end

  def ~@
    self.class.new(-y, x)   #使坐标旋转90度
  end

  def [](index)
    case index
    when 0
      x
    when 1
      y
    else
      raise ArgumentError, "out of range '#{index}'"
    end
  end

  def []=(index, val)
    case index
    when 0
      self.x = val
    when 1
      self.y = val
    else
      raise ArgumentError, "out of range '#{index}'"
    end
  end
end

point1 = Point.new(3, 6)
point2 = Point.new(1, 8)

p point1
p point2
p point1 + point2
p point1 - point2

#p +point1
#p -point1
p ~point1

p point1[0]
#p point1[1] = 2
p point1[1]
p point1[2]
