//初始化代码对比区域
$('#mergely').mergely({
    license: 'lgpl-separate-notice',
    width: 1200,
    height: 350,
    wrap_lines: true,
    line_numbers: false,
    lhs: function (setValue) {
        setValue("the quick red fox\njumped over the hairy dog"); //初始化左边区域
    },
    rhs: function (setValue) {
        setValue("the quick brown fox\njumped over the lazy dog"); //初始化右边区域
    }
});

//只读，不可编辑，根据个人需要，要或不要
$('#mergely').mergely('cm', 'lhs').options.readOnly = false;
$('#mergely').mergely('cm', 'rhs').options.readOnly = false;
