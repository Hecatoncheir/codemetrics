part of codemetrics.cyclomatic;

/**
 * Visitor implementation to calculate the cyclomatic complexity
 * of a [Declaration]
 */
class ControlFlowVisitor extends RecursiveAstVisitor<Object> {
  /**
   * Complexity of each `Declaration`
   */
  int _complexity = 1;

  /**
   * Complexity of a [Declaration]
   */
  int get complexity => _complexity;

  final CyclomaticConfig config;

  ControlFlowVisitor(this.config);

  /**
   * Increases an internal counter that represent the complexity of the
   * function/method
   * Use [complexity] to read the complexity of a given [Declaration]
   */
  void increaseComplexity(String configOptionToConsider) {
    if (!CYCLOMATIC_CONFIG_OPTIONS.contains(configOptionToConsider)) {
      throw new ArgumentError.value(configOptionToConsider);
    }
    _complexity +=
        config.addedComplexityByControlFlowType[configOptionToConsider];
  }

  @override
  void visitAssertStatement(AssertStatement node) {
    increaseComplexity('assertStatement');
    super.visitAssertStatement(node);
  }

  @override
  void visitBlockFunctionBody(BlockFunctionBody node) {
    Token tok = node.beginToken;
    while (tok != node.block.rightBracket) {
      if (tok.matchesAny(
          const [TokenType.AMPERSAND_AMPERSAND, TokenType.BAR_BAR])) {
        increaseComplexity('blockFunctionBody');
      }
      tok = tok.next;
    }
    super.visitBlockFunctionBody(node);
  }

  @override
  void visitCatchClause(CatchClause node) {
    increaseComplexity('catchClause');
    super.visitCatchClause(node);
  }

  @override
  void visitConditionalExpression(ConditionalExpression node) {
    increaseComplexity('conditionalExpression');
    super.visitConditionalExpression(node);
  }

  @override
  void visitForStatement(ForStatement node) {
    increaseComplexity('forStatement');
    super.visitForStatement(node);
  }

  @override
  void visitIfStatement(IfStatement node) {
    increaseComplexity('ifStatement');
    super.visitIfStatement(node);
  }

  @override
  void visitSwitchDefault(SwitchDefault node) {
    increaseComplexity('switchDefault');
    super.visitSwitchDefault(node);
  }

  @override
  void visitSwitchCase(SwitchCase node) {
    increaseComplexity('switchCase');
    super.visitSwitchCase(node);
  }

  @override
  void visitWhileStatement(WhileStatement node) {
    increaseComplexity('whileStatement');
    super.visitWhileStatement(node);
  }

  @override
  void visitYieldStatement(YieldStatement node) {
    increaseComplexity('yieldStatement');
    super.visitYieldStatement(node);
  }
}
