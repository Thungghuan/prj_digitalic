import math

INPUT_PORT = 'sin_in'
OUTPUT_PORT = 'sin_out'
SIGN_PORT = 'sign'
FILENAME = 'rtl/sin.v'
PRECISION = 12


def main():
    sin_in_range = 1024

    print('Generate {} cases of verilog codes'.format(sin_in_range))

    print('Starting generating...')

    with open(FILENAME, 'w') as f:
        f.write('module sin({}, {}, {});\n\n'.format(
            INPUT_PORT, OUTPUT_PORT, SIGN_PORT))
        f.write('input [9:0] {};\n'.format(INPUT_PORT))
        f.write('output reg [12:0] {};\n'.format(OUTPUT_PORT))
        f.write('output reg {};\n\n'.format(SIGN_PORT))
        f.write('wire [1:0] high;\n')
        f.write('wire [7:0] low;\n\n')
        f.write('assign { high, low } = sin_in;\n\n')
        f.write('always @(*) begin\n')

        f.write('    case (high)\n')

        step = 0
        for i in range(4):
            f.write("        2'b{:0>2b}: begin\n".format((i)))

            if i > 1:
                f.write("            {} <= 1'b1;\n".format(SIGN_PORT))
            else:
                f.write("            {} <= 1'b0;\n".format(SIGN_PORT))

            f.write("            case (low)\n")
            for sin_in in range(256):
                f.write(get_sin_result(sin_in, sin_in_range, step))
            f.write('            endcase\n')

            f.write("        end\n")
            step = step + 1

        f.write('    endcase\nend\n\nendmodule\n')

    print('Succefully generated, see sin.v')


def get_sin_result(sin_in, sin_in_range, times=0, hex=False):
    indent = '                '

    # 在range中计算sin
    result = math.sin(2 * math.pi * (sin_in + 256 * times) / sin_in_range)

    # 调整二进制精度
    result = round(result * (2 ** PRECISION))

    # 处理12位有符号负数值
    if result < 0:
        result = -result
        # result = 2 ** (PRECISION + 2) + result

    if not hex:
        # 转化为二进制表示
        result = "{}'b{{:0>{}b}}".format(
            PRECISION + 1, PRECISION + 1).format(result)
    else:
        # 转化为十六进制表示
        result = "16'h" + "{:0>4x}".format(result).upper()

    return "{}8'd{:0>3}: {} <= {};\n".format(indent, sin_in, OUTPUT_PORT, result)


main()

