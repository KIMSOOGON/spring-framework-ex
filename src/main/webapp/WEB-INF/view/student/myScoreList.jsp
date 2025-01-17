<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimal-ui">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />

    <meta name="keywords" content="bootstrap, bootstrap admin template, admin theme, admin dashboard, dashboard template, admin template, responsive" />
    <meta name="author" content="Codedthemes" />
    <!-- Favicon icon -->
    <link rel="icon" href="${pageContext.request.contextPath}/resources/images/favicon.ico" type="image/x-icon">
    <!-- Google font-->
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:400,600,700" rel="stylesheet">
    <!-- waves.css -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/pages/waves/css/waves.min.css" type="text/css" media="all">
    <!-- Required Fremwork -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/bootstrap/css/bootstrap.min.css">
    <!-- themify icon -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/icon/themify-icons/themify-icons.css">
    <!-- font-awesome-n -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/font-awesome-n.min.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/font-awesome.min.css">
    <!-- scrollbar.css -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/jquery.mCustomScrollbar.css">
    <!-- Style.css -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/style.css">

	<!-- chart -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.5.0/Chart.min.js"></script>
</head>
<body>
	
	
	<div id="pcoded" class="pcoded">
		<div class="pcoded-overlay-box"></div>
		<div class="pcoded-container navbar-wrapper">
			<!-- Top Menu Bar include -->
			<div>
				<c:import url="/WEB-INF/view/inc/topMenu.jsp"></c:import>
			</div>
			<div class="pcoded-main-container">
				<div class="pcoded-wrapper"> 
				<!-- Side Menu Bar include -->
					<div>
						<c:import url="/WEB-INF/view/inc/sideMenu.jsp"></c:import>
					</div>
					
					<!-- 메인화면 -->
                    <div class="pcoded-content">
                        <!-- Page-header start -->
                        <div class="page-header">
                            <div class="page-block">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <div class="page-header-title">
                                            <h5 class="m-b-10">${loginStudent.studentName}님의 응시한 시험의 성적/석차/답안지 확인</h5>
                                            <p class="m-b-0">
                                            	
                                            </p>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <ul class="breadcrumb">
                                            <li class="breadcrumb-item">
                                                <a href="index.html"> <i class="fa fa-home"></i> </a>
                                            </li>
                                            <li class="breadcrumb-item"><a href="#!">Home</a>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Page-header end -->
                        <div class="pcoded-inner-content">
                            <!-- Main-body start -->
                            <div class="main-body">
                                <div class="page-wrapper">
                                    <!-- Page-body start -->
                                    <div class="page-body">
                                        <!-- Hover table card start -->
                                        <div class="card">
                                            <div class="card-header">
                                                <h5>내 성적 목록</h5>
												<!-- 시험검색 -->
												
												<form class="mt-2 text-center form-material" method="get" action="${pageContext.request.contextPath}/student/myScoreList">
													<div class="form-group form-primary">
														<select name="rowPerPage">
															<c:if test="${rowPerPage == 5}">
																<option value="5" selected="selected">5</option>
																<option value="10">10</option>
																<option value="20">20</option>
															</c:if>
															<c:if test="${rowPerPage == 10}">
																<option value="5">5</option>
																<option value="10" selected="selected">10</option>
																<option value="20">20</option>
															</c:if>
															<c:if test="${rowPerPage == 20}">
																<option value="5">5</option>
																<option value="10">10</option>
																<option value="20" selected="selected">20</option>
															</c:if>
														</select>
														<input type="text" name="searchWord" placeholder="시험명을 검색하세요" value="${searchWord}" style="width:400px; background-color:#FFFFE4;" class="form-control ml-1">
														<button class="btn btn-sm btn-success" type="submit"><i class="fa fa-search m-r-10"></i></button>
													</div>
												</form>
												

                                                <div class="card-header-right">
                                                    <ul class="list-unstyled card-option">
                                                        <li><i class="fa fa fa-wrench open-card-option"></i></li>
                                                        <li><i class="fa fa-window-maximize full-card"></i></li>
                                                        <li><i class="fa fa-minus minimize-card"></i></li>
                                                        <li><i class="fa fa-refresh reload-card"></i></li>
                                                        <li><i class="fa fa-trash close-card"></i></li>
                                                    </ul>
                                                </div>
                                            </div>
                                            <div class="card-block table-border-style">
                                                <div class="table-responsive">
                                                	<!-- 응시한 시험 및 점수 출력 -->
                                                    <table class="table table-hover">
														<thead>
															<tr>
																<th>No.</th>
																<th>시험제목</th>
																<th>성적</th>
																<th>석차</th>
																<th>응시날짜</th>
																<th>답안지 확인</th>
															</tr>
														</thead>
														<tbody>
															<c:forEach var="s" items="${list}" varStatus="status">
																<tr>
																	<td>${status.count+beginRow}</td>
																	<td>
																		<a href="${pageContext.request.contextPath}/student/scoreOne?scoreNo=${s.scoreNo}">${s.testTitle}</a>
																	</td>
																	<td class="text-danger">${s.score}</td>
																	<td><span style="font-weight:bold;">${s.ranking}</span> / ${s.ttlStudent}</td>
																	<td>${s.scoreDate}</td>
																	<td><a href="${pageContext.request.contextPath}/student/scoreOne?scoreNo=${s.scoreNo}" class="btn btn-sm btn-info">답안지 확인</a></td>
																</tr>
															</c:forEach>
														</tbody>
													</table>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							<!-- 페이징 -->
							<div class="container text-center">
								<nav>
									<ul class="pagination">
										<li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/student/myScoreList?currentPage=1&searchWord=${searchWord}&rowPerPage=${rowPerPage}"><i class="ti-angle-double-left"></i></a></li>
										<c:if test="${currentPage > 10}">
											<li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/student/myScoreList?currentPage=${startPage-10}&searchWord=${searchWord}&rowPerPage=${rowPerPage}"><i class="ti-angle-left"></i></a></li>
										</c:if>
										<c:forEach var="i" begin="${startPage}" end="${endPage}" step="1">
											<c:choose>
												<c:when test="${currentPage == i}">
													<li class="page-item"><span style="font-weight:bold; color:orange;"><a class="page-link">${i}</a></span></li>
												</c:when>
												<c:otherwise>
													<li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/student/myScoreList?currentPage=${i}&searchWord=${searchWord}&rowPerPage=${rowPerPage}">${i}</a></li>
												</c:otherwise>
											</c:choose>
										</c:forEach>
										<c:if test="${(lastPage-startPage) > 10}">
											<li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/student/myScoreList?currentPage=${startPage+10}&searchWord=${searchWord}&rowPerPage=${rowPerPage}"><i class="ti-angle-right"></i></a></li>
										</c:if>
										<li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/student/myScoreList?currentPage=${lastPage}&rowPerPage=${rowPerPage}"><i class="ti-angle-double-right"></i></a></li>
									</ul>
								</nav>
							</div>
						</div>
							
						  	<!-- Page-header end -->
	                        <div class="pcoded-inner-content">
	                            <!-- Main-body start -->
	                            <div class="main-body">
	                                <div class="page-wrapper">
	                                    <!-- Page-body start -->
	                                    <div class="page-body">
	                                        <!-- Hover table card start -->
	                                        <div class="card">
	                                            <div class="card-header">
	                                                <h5>내 성적 (차트)</h5>
	                                                
	                                                <div class="card-header-right">
                                                    <ul class="list-unstyled card-option">
                                                        <li><i class="fa fa fa-wrench open-card-option"></i></li>
                                                        <li><i class="fa fa-window-maximize full-card"></i></li>
                                                        <li><i class="fa fa-minus minimize-card"></i></li>
                                                        <li><i class="fa fa-refresh reload-card"></i></li>
                                                        <li><i class="fa fa-trash close-card"></i></li>
                                                    </ul>
                                                </div>
                                            </div>
                                            <div class="card-block table-border-style">
                                                <div class="table-responsive">
                                                	<!-- 응시한 시험 및 점수 출력 -->
													<canvas id="myChart" style="width:100%;max-width:800px"></canvas>
													<!-- 차트 모델값을 가져오는 코드 -->
													<script>
														// 모델 데이터 가져온 후에 아래 차트가 그려져야 한다 -> 동기로 처리해야 한다
														// async값을 false로 변경  참고 => https://api.jquery.com/jQuery.ajax/
														let xModel = []; // 키배열
														let yModel = []; // 합배열
														let barColorsModel = ['#00FF00','#0000FF','#AB4297','#883259','#CACC55','#AABBCC','#ABCDEF','#987654','#518393','#777799','#D3F2A8'];
														$.ajax({
															async : false
															, url : '/online-test/scoreChart'
															, type : 'get'
															, success : function(model) { // model : /restapi/monthData 백엔드에서 객체로 반환 -> 변환이 필요
																for(let attr in model) { // attr에는 키(속성)값 {1:500, 2:400}
																	xModel.push(model[attr].scoreDate);
																	yModel.push(model[attr].score);
																}
															}
														});
													</script>
													
													<!-- 차트를 그리는 코드 -->
													<script>
													var xValues = xModel;
													var yValues = yModel;
													var barColors = barColorsModel;
													
													new Chart("myChart", {
													  type: "bar",
													  data: {
													    labels: xValues,
													    datasets: [{
													      backgroundColor: barColors,
													      data: yValues
													    }]
													  },
													  options: {
														  scales: {
															  yAxes: [{
																  ticks: {
																	  min:0,
																	  max:100
																  }
															  }]
														  },
													    legend: {display: false},
													    title: {
													      display: true,
													      text: "성적"
													    }
													  }
													});
													</script>
												</div>
											</div>
										</div>
									</div>
								</div>								
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
    <!-- Required Jquery -->
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery/jquery.min.js "></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-ui/jquery-ui.min.js "></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/popper.js/popper.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/js/bootstrap.min.js "></script>
    <!-- waves js -->
    <script src="${pageContext.request.contextPath}/resources/pages/waves/js/waves.min.js"></script>
    <!-- jquery slimscroll js -->
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-slimscroll/jquery.slimscroll.js"></script>

    <!-- slimscroll js -->
    <script src="${pageContext.request.contextPath}/resources/js/jquery.mCustomScrollbar.concat.min.js "></script>

    <!-- menu js -->
    <script src="${pageContext.request.contextPath}/resources/js/pcoded.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/vertical/vertical-layout.min.js "></script>

    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/script.js "></script>
</body>
</html>