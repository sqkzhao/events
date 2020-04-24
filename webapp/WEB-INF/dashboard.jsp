<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
	<head>
		<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
		<title>Events</title>
	</head>
	<body>
		<div class="container">
			<div class="row">
				<h1 class="col-10">
					Welcome
					<c:if test="${currentUser!=null}">
					, <c:out value="${currentUser.firstName}"/>
					</c:if>
				</h1>
				<a href="/" class="py-3 mr-3">Login</a>
				<a href="/logout" class="py-3">Logout</a>
			</div>
			<!-- ACCESS DENIED ERROR -->
			<p class="text-danger"><c:out value="${accessError}"/></p>
			<h5>Here are some of the events in your state:</h5>
			<table class="table">
				<thead>
					<tr>
						<th>Name</th>
						<th>Date</th>
						<th>Location</th>
						<th>Host</th>
						<th>Action/Status</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${allLocalEvents}" var="localEvent">
						<tr>
							<td><a href="/events/${localEvent.id}"><c:out value="${localEvent.name}" /></a></td>
							<td><fmt:formatDate dateStyle = "long" value = "${localEvent.date}" /></td>
							<td><c:out value="${localEvent.location}" /></td>
							<td><c:out value="${localEvent.user.firstName}" /></td>
							<td class="row">
								<c:if test="${currentUser.id == localEvent.user.id}" >
									<a href="/events/${localEvent.id}/edit" class="btn btn-sm btn-dark">Edit</a>
									<form action="/events/${localEvent.id}" method="post">
										<input type="hidden" name="_method" value="delete" />
										<input type="submit" value="Delete" class="btn btn-sm btn-danger mx-3"/>
									</form>
								</c:if>
								<c:if test="${currentUser.id != localEvent.user.id}" >
									<c:if test="${!joinedEvents.contains(localEvent)}">
										<form action="/events/join" method="post">
											<input type="hidden" name="memberId" value="${currentUser.id}" />
											<input type="hidden" name="eventId" value="${localEvent.id}" />
											<input type="submit" value="Join" class="btn btn-sm btn-dark" />
										</form>
									</c:if>
									<c:if test="${joinedEvents.contains(localEvent)}">
										<div class="row">
											<span class="px-3">Joining</span>
											<form action="/events/cancel" method="post">
												<input type="hidden" name="memberId" value="${currentUser.id}" />
												<input type="hidden" name="eventId" value="${localEvent.id}" />
												<input type="submit" value="Cancel" class="btn btn-sm btn-danger" />
											</form>
										</div>
									</c:if>
								</c:if>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			<h5>Here are some of the events in other state:</h5>
			<table class="table">
				<thead>
					<tr>
						<th>Name</th>
						<th>Date</th>
						<th>Location</th>
						<th>Host</th>
						<th>Action/Status</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${otherEvents}" var="e">
						<tr>
							<td><a href="/events/${e.id}"><c:out value="${e.name}" /></a></td>
							<td><fmt:formatDate dateStyle = "long" value = "${e.date}" /></td>
							<td><c:out value="${e.location}" /></td>
							<td><c:out value="${e.user.firstName}" /></td>
							<td class="row">
								<c:if test="${currentUser.id != null}">
									<c:if test="${currentUser.id == e.user.id}" >
										<a href="/events/${e.id}/edit" class="btn btn-sm btn-dark">Edit</a>
										<form action="/events/${e.id}" method="post">
											<input type="hidden" name="_method" value="delete" />
											<input type="submit" value="Delete" class="btn btn-sm btn-danger mx-3"/>
										</form>
									</c:if>
									<c:if test="${currentUser.id != e.user.id}" >
										<c:if test="${!joinedEvents.contains(e)}">
											<form action="/events/join" method="post">
												<input type="hidden" name="memberId" value="${currentUser.id}" />
												<input type="hidden" name="eventId" value="${e.id}" />
												<input type="submit" value="Join" class="btn btn-sm btn-dark" />
											</form>
										</c:if>
										<c:if test="${joinedEvents.contains(e)}">
											<div class="row">
												<span class="px-3">Joining</span>
												<form action="/events/cancel" method="post">
													<input type="hidden" name="memberId" value="${currentUser.id}" />
													<input type="hidden" name="eventId" value="${e.id}" />
													<input type="submit" value="Cancel" class="btn btn-sm btn-danger" />
												</form>
											</div>
										</c:if>
									</c:if>
								</c:if>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			<hr/>
			<h5>Create an Event</h5>
			<form:form action="/events" method="post" modelAttribute="event">
				<p>
					<form:label path="name">Name</form:label>
					<form:input path="name" />
				</p>
				<p><form:errors path="name" class="text-danger" /></p>
				<p>
					<form:label path="date">Date</form:label>
					<form:input path="date" type="date" />
				</p>
				<p><form:errors path="date" class="text-danger" /></p>
				<p>
					<form:label path="location">Location</form:label>
					<form:input path="location" />
					<form:select path="state">
						<form:option value=""></form:option>
						<form:option value="ca">CA</form:option>
						<form:option value="ny">NY</form:option>
						<form:option value="ut">UT</form:option>
					</form:select>
				</p>
				<p><form:errors path="location" class="text-danger" /></p>
				<p><form:errors path="state" class="text-danger" /></p>
				<form:input path="user" type="hidden" value="${currentUser.id}" />
				<c:if test="${currentUser.id != null}">
					<input type="submit" value="Create event!" class="btn btn-dark" />
				</c:if>
				<c:if test="${currentUser.id == null}">
					<input type="submit" value="Create event!" class="btn btn-dark" disabled />
					<p>Please login to create event</p>
				</c:if>
			</form:form>
		</div>
	</body>
</html>