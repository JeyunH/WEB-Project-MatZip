package kr.ac.kopo.vo;

public class PaginationVO {

    private int totalCount;     // 총 게시물 수
    private int currentPage;    // 현재 페이지 번호
    private int totalPage;      // 전체 페이지 수
    private int startPage;      // 시작 페이지 번호
    private int endPage;        // 끝 페이지 번호
    private int pageSize;       // 한 페이지에 보여줄 게시물 수
    private int displayPageCount; // 한 번에 보여줄 페이지 번호 개수

    public PaginationVO(int totalCount, int currentPage, int pageSize, int displayPageCount) {
        this.totalCount = totalCount;
        this.currentPage = currentPage;
        this.pageSize = pageSize;
        this.displayPageCount = displayPageCount;
        calculate();
    }

    private void calculate() {
        // 1. 전체 페이지 수 계산
        totalPage = (int) Math.ceil((double) totalCount / pageSize);
        if (totalPage == 0) totalPage = 1;

        // 2. 현재 페이지 보정
        if (currentPage > totalPage) currentPage = totalPage;
        if (currentPage < 1) currentPage = 1;

        // 3. 시작 페이지와 끝 페이지 계산 (현재 페이지가 중앙에 오도록)
        int halfDisplayCount = displayPageCount / 2;
        startPage = currentPage - halfDisplayCount;
        endPage = startPage + displayPageCount - 1;

        // 4. 시작 페이지가 1보다 작은 경우 보정
        if (startPage < 1) {
            startPage = 1;
            endPage = Math.min(displayPageCount, totalPage);
        }

        // 5. 끝 페이지가 전체 페이지 수를 초과하는 경우 보정
        if (endPage > totalPage) {
            endPage = totalPage;
            startPage = Math.max(1, endPage - displayPageCount + 1);
        }
    }

    // Getters
    public int getTotalCount() {
        return totalCount;
    }

    public int getCurrentPage() {
        return currentPage;
    }

    public int getTotalPage() {
        return totalPage;
    }

    public int getStartPage() {
        return startPage;
    }

    public int getEndPage() {
        return endPage;
    }

    public int getPageSize() {
        return pageSize;
    }

    public int getDisplayPageCount() {
        return displayPageCount;
    }
}
