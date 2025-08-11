function autoResize(textarea) {
    // Reset height to auto to get accurate scrollHeight
    textarea.style.height = 'auto';
    
    // Set height to scrollHeight (content height)
    textarea.style.height = textarea.scrollHeight + 'px';
}

// Apply to all auto-resize textareas
document.querySelector('#prompt').addEventListener('input', function() {
    autoResize(this);
});