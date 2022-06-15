import math

INPUT_PORT = 'sin_in'
OUTPUT_PORT = 'sin_out'
FILENAME = 'rtl/sin.v'
PRECISION = 12


def main():
    sin_in_range = 1024

    print('Generate {} cases of verilog codes'.format(sin_in_range))

    print('Starting generating...')

    with open(FILENAME, 'w') as f:
        f.write('module module_sin({}, {});\n\n'.format(
            INPUT_PORT, OUTPUT_PORT))
        f.write('input [9:0] {};\n'.format(INPUT_PORT))
        f.write('output [13:0] {};\n\n'.format(OUTPUT_PORT))
        f.write('reg [13:0] {};\n\n'.format('out'))
        f.write('wire [1:0] high;\n')
        f.write('wire [7:0] low;\n\n')
        f.write('assign { high, low } = sin_in;\n\n')
        f.write('assign sin_out = out;\n\n')
        f.write('always @(*)\n')
        f.write('begin\n')

        f.write('    case (high)\n')
        f.write("        2'b00: \n")

        f.write("        begin\n")
        f.write("            case (low)\n")
        for sin_in in range(256):
            f.write(get_sin_result(sin_in, sin_in_range))
        f.write('            endcase')
        f.write("        end\n")

        f.write("        2'b01: \n")

        f.write("        begin\n")
        f.write("            case (low)\n")
        for sin_in in range(256):
            f.write(get_sin_result(sin_in, sin_in_range, 1))
        f.write('            endcase')
        f.write("        end\n")

        f.write("        2'b10: \n")

        f.write("        begin\n")
        f.write("            case (low)\n")
        for sin_in in range(256):
            f.write(get_sin_result(sin_in, sin_in_range, 2))
        f.write('            endcase')
        f.write("        end\n")

        f.write("        2'b11: \n")

        f.write("        begin\n")
        f.write("            case (low)\n")
        for sin_in in range(256):
            f.write(get_sin_result(sin_in, sin_in_range, 3))
        f.write('            endcase')

        f.write("        end\n")

        # f.write('    case ({})\n'.format(INPUT_PORT))

        # for sin_in in range(sin_in_range):
        #     f.write(get_sin_result(sin_in, sin_in_range))

        f.write('    endcase\n')
        f.write('end\n\nendmodule')

    print('Succefully generated, see sin.v')


def get_sin_result(sin_in, sin_in_range, times = 0, hex=False):
    indent = '                '

    # 在range中计算sin
    result = math.sin(2 * math.pi * (sin_in + 256 * times) / sin_in_range)

    # 调整二进制精度
    result = round(result * (2 ** PRECISION))

    # 处理12位有符号负数值
    if result < 0:
        result = 2 ** (PRECISION + 2) + result

    if not hex:
        # 转化为二进制表示
        result = "{}'b{{:0>{}b}}".format(
            PRECISION + 2, PRECISION + 2).format(result)
    else:
        # 转化为十六进制表示
        result = "16'h" + "{:0>4x}".format(result).upper()

    return "{}8'd{:0>3}: {} <= {};\n".format(indent, sin_in, 'out', result)


main()
