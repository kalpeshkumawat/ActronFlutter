class SystemOperationRegisterModels {
  SystemOperationRegisterModels({
    this.leading = '',
    this.trailing = '--',
    this.reg = 0,
    this.bit = 0,
    this.type = '--',
    this.toggleButton = false,
    this.select = false,
  });
  String leading;
  String trailing;
  int reg;
  int bit;
  String type;
  bool toggleButton;
  bool select;
}
