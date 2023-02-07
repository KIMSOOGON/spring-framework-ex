package goodee.gdj58.online.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import goodee.gdj58.online.controller.StudentController;
import goodee.gdj58.online.mapper.StudentMapper;
import goodee.gdj58.online.vo.Paper;
import goodee.gdj58.online.vo.Score;
import goodee.gdj58.online.vo.Student;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class StudentService {
	@Autowired private StudentMapper studentMapper;
	// ====================== 시험 관련 ========================
	// score매기기
	public int getScorePaper(int testNo, int studentNo) {
		int ttlQuestionCnt = studentMapper.ttlQuestionCnt(testNo);
		int ttlCorrectCnt = studentMapper.ttlCorrectCnt(testNo);
		int myScore = (int)(((double)ttlCorrectCnt / (double)ttlQuestionCnt) * 100);
		// 점수 -> 소수점이하는 버림
		log.debug("\u001B[31m"+"총 문항 수 : "+ttlQuestionCnt);
		log.debug("\u001B[31m"+"맞힌 문항 수 : "+ttlCorrectCnt);
		log.debug("\u001B[31m"+"내 점수 : "+myScore);
		Score score = new Score();
		score.setStudentNo(studentNo);
		score.setTestNo(testNo);
		score.setScore(myScore);
		return studentMapper.insertScorePaper(score);
	}
	
	// 채점 (해당 문제의 정답 여부 확인)
	public int getQuestionOx(int questionNo) {
		return studentMapper.selectQuestionOx(questionNo);
	}
	
	// paper 등록 (학생이 제출한 답지등록)
	public int addPaper(Paper paper) {
		return studentMapper.insertPaperAnswer(paper);
	}
	
	// 해당회차시험 문제 목록 (해당회차 시험 문제 및 4지선다 확인)
	public List<Map<String,Object>> getExampleList(int testNo) {
		return studentMapper.selectExampleList(testNo);
	}

	// ====================== 학생 관련 =========================
	// 비밀번호수정
	public int updateStudentPw(int studentNo, String oldPw, String newPw) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("studentNo", studentNo);
		paramMap.put("oldPw", oldPw);
		paramMap.put("newPw", newPw);
		System.out.println(paramMap.get("newPw"));
		return studentMapper.updateStudentPw(paramMap);
	}
	
	// 학생 로그인
	public Student login(Student student) {
		return studentMapper.login(student);
	}
		
	// 학생삭제
	public int removeStudent(int studentNo) {
		return studentMapper.deleteStudent(studentNo);
	}
	
	// 학생등록
	public int addStudent(Student student) {
		return studentMapper.insertStudent(student);
	}
	
	// 총 학생 수
	public int ttlStuCnt(String searchWord) {
		return studentMapper.ttlStuCnt(searchWord);
	}
		
	// 학생목록
	public List<Student> getStudentList(int currentPage, int rowPerPage, String searchWord) {
		int beginRow = (currentPage-1)*rowPerPage;
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("beginRow", beginRow);
		paramMap.put("rowPerPage", rowPerPage);
		paramMap.put("searchWord", searchWord);
		return studentMapper.selectStudentList(paramMap);
	}
}
