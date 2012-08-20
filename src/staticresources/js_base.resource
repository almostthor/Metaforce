function toggleSidebarItem(linkElement) {
  var sidebarItem = $(linkElement).up(".sidebarItem");

  if (!sidebarItem) return;

  if (sidebarItem.hasClassName("open")) {
    sidebarItem.removeClassName("open");
    sidebarItem.addClassName("closed");
  } else {
    sidebarItem.removeClassName("closed");
    sidebarItem.addClassName("open");    
  }
}

function focusTitle(fieldElement) {
    if (fieldElement.className.indexOf('ibtTitleFieldInitial') > -1) {
        fieldElement.className = 'ibtTitleFieldFocus';
        fieldElement.value = '';
    }
}