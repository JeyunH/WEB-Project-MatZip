<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script>
document.addEventListener("DOMContentLoaded", function() {
    const modal = document.getElementById("imageModal");
    if (!modal) return; // 모달이 없으면 스크립트 실행 중단

    const modalImg = document.getElementById("modalImg");
    const closeBtn = modal.querySelector(".modal-close");
    const leftBtn = modal.querySelector(".modal-button.left");
    const rightBtn = modal.querySelector(".modal-button.right");

    let modalState = {
        images: [],
        currentIndex: 0
    };

    function openModal(images, startIndex) {
        modalState.images = images;
        modalState.currentIndex = startIndex;
        updateModalImage();
        modal.classList.add("active");
    }

    function closeModal() {
        modal.classList.remove("active");
    }

    function changeImage(step) {
        if (modalState.images.length === 0) return;
        const newIndex = (modalState.currentIndex + step + modalState.images.length) % modalState.images.length;
        modalState.currentIndex = newIndex;
        updateModalImage();
    }
    
    function updateModalImage() {
        modalImg.src = modalState.images[modalState.currentIndex];
    }

    // 이벤트 위임을 사용하여 이미지 클릭 처리
    document.querySelector('.table-container').addEventListener('click', function(e) {
        if (e.target.classList.contains('thumbnail')) {
            const imageContainer = e.target.closest('.review-images');
            if (imageContainer) {
                const allThumbnails = Array.from(imageContainer.querySelectorAll('.thumbnail'));
                const imageUrls = allThumbnails.map(img => img.src);
                const clickedIndex = allThumbnails.indexOf(e.target);
                openModal(imageUrls, clickedIndex);
            }
        }
    });
    
    // 모달 제어 이벤트
    closeBtn.addEventListener('click', closeModal);
    modal.addEventListener('click', (e) => {
        if (e.target === modal) closeModal();
    });
    leftBtn.addEventListener('click', (e) => { e.stopPropagation(); changeImage(-1); });
    rightBtn.addEventListener('click', (e) => { e.stopPropagation(); changeImage(1); });

    // 키보드 이벤트
    window.addEventListener('keydown', function(e) {
      if (!modal.classList.contains('active')) return;
      if (e.key === 'ArrowLeft') { e.preventDefault(); changeImage(-1); }
      else if (e.key === 'ArrowRight') { e.preventDefault(); changeImage(1); }
      else if (e.key === 'Escape') { e.preventDefault(); closeModal(); }
    });
});
</script>
