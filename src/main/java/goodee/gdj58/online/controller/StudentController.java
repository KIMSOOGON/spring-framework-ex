package goodee.gdj58.online.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import goodee.gdj58.online.service.IdService;
import goodee.gdj58.online.service.StudentService;
import goodee.gdj58.online.service.TeacherService;
import goodee.gdj58.online.vo.Employee;
import goodee.gdj58.online.vo.Paper;
import goodee.gdj58.online.vo.Student;
import goodee.gdj58.online.vo.Test;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class StudentController {
	@Autowired StudentService studentService;
	@Autowired TeacherService teacherService;
	@Autowired IdService idService;
	
	// ====================== 시험 관련 ============================
	// 답안지 제출 (paper등록)
	@PostMapping("/student/addPaper")
	public String addPaper(@RequestParam(value="questionNo") int[] questionNo
							, @RequestParam(value="answer") int[] answer
							, @RequestParam(value="testNo") int testNo
							, @RequestParam(value="studentNo") int studentNo) {
		log.debug("\u001B[31m"+"questionIdx 0 : "+questionNo[0]);
		log.debug("\u001B[31m"+"questionIdx 1 : "+questionNo[1]);
		log.debug("\u001B[31m"+"answer 0 : "+answer[0]);
		log.debug("\u001B[31m"+"answer 1 : "+answer[1]);
		int questionCnt = questionNo.length; // 문항 갯수
		
		Paper[] paper = new Paper[questionCnt]; // 문항 갯수만큼의 Paper 배열선언
		for(int i=0; i<questionCnt; i++) {
			paper[i] = new Paper();
			paper[i].setStudentNo(studentNo);
			paper[i].setTestNo(testNo);
			paper[i].setQuestionNo(questionNo[i]);
			paper[i].setAnswer(answer[i]); // 제출한 답안
			int correctAnswer = studentService.getQuestionOx(questionNo[i]); // 실제 문제의 정답
			log.debug("\u001B[31m"+"corretAnswer: "+correctAnswer);
			if(correctAnswer == paper[i].getAnswer()) {
				// 제출답안과 실제정답이 일치할 경우
				paper[i].setAnswerOx("정답");
			} else {
				paper[i].setAnswerOx("오답"); 
			}
			int addPaper = studentService.addPaper(paper[i]);
			if(addPaper == 1) {
				log.debug("\u001B[31m"+testNo+"번 시험 "+questionNo[i]+"번 문항 답안제출 완료");
			}
		}
		return "redirect:/testList";
	}
	
	// 시험지 출력 
	@GetMapping("/student/examTest")
	public String examTest(Model model
							, @RequestParam(value="testNo") int testNo) {
		List<Map<String,Object>> list = studentService.getExampleList(testNo);
		Test thisTest = teacherService.thisTest(testNo);

		model.addAttribute("list", list);
		// model.addAttribute("answerList", answerList);
		model.addAttribute("thisTest", thisTest);
		return "student/examTest";
	}
		
	// ====================== 학생 관련 CRUD ========================
	// pw수정
	@GetMapping("/student/modifyStudentPw")
	public String modifyStudentPw() {
		return "student/modifyStudentPw";
	}
	@PostMapping("/student/modifyStudentPw")
	public String modifyStudentPw(HttpSession session
							, @RequestParam(value="oldPw") String oldPw
							, @RequestParam(value="newPw") String newPw) {
		Student loginStudent = (Student)session.getAttribute("loginStudent");
		System.out.println(loginStudent.getStudentNo()+oldPw+newPw);
		studentService.updateStudentPw(loginStudent.getStudentNo(), oldPw, newPw);
		return "redirect:/Home";
	}
	
	// 로그인 폼
	@GetMapping("/loginStudent")
	public String loginEmp() { // 세션이 필요한 로직은 매개변수로 세션을 받아온다
		return "student/loginStudent";
	}
	// 로그인 액션
	@PostMapping("/loginStudent")
	public String loginEmp(HttpSession session, Student student) { // 세션이 필요한 로직은 매개변수로 세션을 받아온다
		Student resultStudent = studentService.login(student);
		if(resultStudent == null) { // 로그인 실패
			return "redirect:/loginStudent";
		}
		session.setAttribute("loginStudent", resultStudent);
		return "redirect:/Home";
	}
		
	// 삭제 (학생삭제)
	@GetMapping("/employee/removeStudent")
	public String removeStudent(HttpSession session, @RequestParam("studentNo") int studentNo) {
		Employee loginEmp = (Employee)session.getAttribute("loginEmp");
		if(loginEmp == null) {
			return "redirect:/employee/loginEmp";
		}
		
		studentService.removeStudent(studentNo);
		return "redirect:/employee/studentList"; // 리스트로 리다이렉트
	}
	
	// 입력 (학생등록)
	@GetMapping("/employee/addStudent")
	public String addStudent(HttpSession session) {
		Employee loginEmp = (Employee)session.getAttribute("loginEmp");
		if(loginEmp == null) {
			return "redirect:/employee/loginEmp";
		}
		
		return "employee/addStudent"; // forward
	}
	@PostMapping("/employee/addStudent")
	public String addStudent(HttpSession session, Student student) {
		String idCheck = idService.getIdCheck(student.getStudentId());
		if(idCheck != null) {
			return "redirect:/employee/addStudent";
		}
		
		int row = studentService.addStudent(student);
		// row == 1 이면 입력성공
		return "redirect:/employee/studentList"; // sendRedirect, CM -> C (C로 다시 redirect)
	}
	
	@GetMapping("/employee/studentList")
	public String studentList(HttpSession session, Model model
								, @RequestParam(value="currentPage", defaultValue="1") int currentPage
								, @RequestParam(value="rowPerPage", defaultValue="10") int rowPerPage
								, @RequestParam(value="searchWord", defaultValue="") String searchWord) {
		log.debug("\u001B[31m"+"currentPage : "+currentPage);
		log.debug("\u001B[31m"+"searchWord : "+searchWord);
		
		// 페이징관련
		int ttlStuCnt = studentService.ttlStuCnt(searchWord);
		int lastPage = (int)Math.ceil((double)ttlStuCnt / (double)rowPerPage);
		int pageCnt =10;
		int startPage = ((currentPage-1)/pageCnt)*pageCnt + 1;
		int endPage = startPage + pageCnt - 1;
		if(endPage > lastPage) {
			endPage = lastPage;
		}
		
		List<Student> list = studentService.getStudentList(currentPage, rowPerPage, searchWord);
		model.addAttribute("list", list);
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("rowPerPage", rowPerPage);
		model.addAttribute("searchWord", searchWord);
		model.addAttribute("lastPage", lastPage);
		model.addAttribute("ttlStuCnt", ttlStuCnt);
		model.addAttribute("startPage", startPage);
		model.addAttribute("endPage", endPage);
		return "employee/studentList";
	}	
	// ====================== 학생 관련 CRUD ========================
}
