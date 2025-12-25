# BunnyJS

BunnyJS 是一个完全使用 [MoonBit](https://www.moonbitlang.com/) 语言编写的轻量级 JavaScript 解析器（Parser）和解释器（Interpreter）。

## 项目简介

本项目的目标是探索 MoonBit 在构建编程语言工具链方面的潜力，并提供一个可嵌入、高性能的 JavaScript 运行时子集。目前主要支持 JavaScript 的核心语法解析和基础执行能力。

## 主要特性

*   **词法分析与语法解析**：手写的递归下降解析器，不依赖第三方生成工具。
    *   支持变量声明 (`let`, `const`, `var`)
    *   支持函数声明与调用
    *   支持控制流语句 (`if`, `while`, `return`)
    *   支持基础表达式（二元运算、成员访问 `obj.prop`、链式调用）
    *   支持字面量（数字、字符串）
*   **AST 定义**：清晰的抽象语法树结构，易于扩展和遍历。
*   **纯 MoonBit 实现**：充分利用 MoonBit 的强类型系统和 WASM 编译优势，运行高效且安全。

## 快速开始

### 安装

确保你已经安装了 [MoonBit](https://www.moonbitlang.com/download/)。

### 运行测试

```bash
moon test
```

### 使用示例

解析一段简单的 JavaScript 代码：

```moonbit
let code = "let x = 10; console.log(x);"
let ast = @parser.parse(code)
inspect(ast)
```

## 贡献

欢迎提交 Issue 或 Pull Request 来改进解析器支持的语法范围或增强解释器功能。

## 许可证

MIT License
