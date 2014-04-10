// D3 Selectable
//
// Bind selection functionality to `ul`, an ancestor node selection
// with its corresponding child selection 'li'.
// Selection state update rendering takes place in the `update` callback.
//
// (c) 2012 Johannes J. Schmidt, TF

d3.selectable = function selection(ul, li, update) {
  function isParentNode(parentNode, node) {
    if (!node) return false;
    if (node === parentNode) return true;
    return isParentNode(parentNode, node.parentNode);
  }
  function selectFirst(selection) {
    selection.each(function(d, i) {
      if (i === 0) d._selected = true;
    });
  }
  function selectLast(selection) {
    selection.each(function(d, i, j) {
      if (i === selection[j].length - 1) d._selected = true;
    });
  }

  var lastDecision;
  function select(d, node) {
    var parentNode = ul.filter(function() { return isParentNode(this, node); }).node(),
        lis = li.filter(function() { return isParentNode(parentNode, this); });
    // select ranges via `shift` key
    if (d3.event.shiftKey) {
      var firstSelectedIndex, lastSelectedIndex, currentIndex;
      lis.each(function(dl, i) {
        if (dl._selected) {
          firstSelectedIndex || (firstSelectedIndex = i);
          lastSelectedIndex = i;
        }
        if (this === node) currentIndex = i;
      });
      var min = Math.min(firstSelectedIndex, lastSelectedIndex, currentIndex);
      var max = Math.max(firstSelectedIndex, lastSelectedIndex, currentIndex);

      // select all between first and last selected
      // when clicked inside a selection
      lis.each(function(d, i) {
        // preserve state for additive selection
        d._selected = (d3.event.ctrlKey && d._selected) || (i >= min && i <= max);
      });
    } else {
      // additive select with `ctrl` key
      if (!d3.event.ctrlKey) {
        lis.each(function(d) { d._selected = false; });
      }
      d._selected = !d._selected;
    }
    // remember decision
    lastDecision = d._selected;
    update();
  }

  li.on('mousedown', function(d) {
    select(d, this);
  });

  li.on('mouseover', function(d) {
    // dragging over items toggles selection
    if (d3.event.which) {
      d._selected = lastDecision;
      update();
    }
  });

  var keyCodes = {
    up: 38,
    down: 40,
    home: 36,
    end: 35,
    a: 65
  };
  ul.on('keydown', function() {
    if (d3.values(keyCodes).indexOf(d3.event.keyCode) === -1) return;
    if (d3.event.keyCode === keyCodes.a && !d3.event.ctrlKey) return;

    var focus = ul.filter(':focus').node();
    if (!focus) return;

    d3.event.preventDefault();

    var scope = li.filter(function(d) { return isParentNode(focus, this); });
    var selecteds = scope.select(function(d) { return d._selected; });

    if (!d3.event.ctrlKey) {
      scope.each(function(d) { d._selected = false; });
    }

    var madeSelection = false;
    switch (d3.event.keyCode) {
      case keyCodes.up:
        selecteds.each(function(d, i, j) {
          if (scope[j][i - 1]) madeSelection = d3.select(scope[j][i - 1]).data()[0]._selected = true;
        });
        if (!madeSelection) selectLast(scope);
        break;
      case keyCodes.down:
        selecteds.each(function(d, i, j) {
          if (scope[j][i + 1]) madeSelection = d3.select(scope[j][i + 1]).data()[0]._selected = true;
        });
        if (!madeSelection) selectFirst(scope);
        break;
      case keyCodes.home:
        selectFirst(scope);
        break;
      case keyCodes.end:
        selectLast(scope);
        break;
      case keyCodes.a:
        scope.each(function(d) { d._selected = !d3.event.shiftKey; });
        break;
    }
    update();
  });
}