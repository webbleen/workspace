#! /usr/bin/ruby

# 检查文件是否存在
p FileTest.exist?("/usr/bin/ruby")
# 文件大小
p FileTest.size("/usr/bin/ruby")

# 圆周率（常量）
p Math::PI
# 2的平凡根
p Math.sqrt(2)

include Math	# 包含Math模块
p PI
p sqrt(2)
