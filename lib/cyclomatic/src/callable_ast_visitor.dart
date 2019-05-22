part of codemetrics.cyclomatic;

class ScopedDeclaration {
  final Declaration declaration;
  final ClassDeclaration enclosingClass;

  ScopedDeclaration(this.declaration, this.enclosingClass);
}

/**
 * Recursive AST visitor implementation to collect methods/functions
 */
class CallableAstVisitor extends RecursiveAstVisitor<Object> {
  final List<ScopedDeclaration> _declarations = [];

  ClassDeclaration enclosingClass;
  /**
   * Get all the declarations collected
   */
  BuiltList<ScopedDeclaration> get declarations =>
      new BuiltList<ScopedDeclaration>(_declarations);

  /**
   * Add a [Declaration] to a list which can be retrieved with [declarations]
   */
  void registerDeclaration(Declaration node) {
    _declarations.add(new ScopedDeclaration(node, enclosingClass));
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    registerDeclaration(node);
    super.visitFunctionDeclaration(node);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    registerDeclaration(node);
    super.visitMethodDeclaration(node);
  }

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    enclosingClass = node;
    super.visitClassDeclaration(node);
    enclosingClass = null;
  }
}
