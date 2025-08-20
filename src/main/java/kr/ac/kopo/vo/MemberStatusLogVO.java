package kr.ac.kopo.vo;

import java.util.Date;
import lombok.Data;

@Data
public class MemberStatusLogVO {
    private int logId;
    private String memberId;
    private String adminId;
    private String previousStatus;
    private String newStatus;
    private String reason;
    private Date logDate;
}
