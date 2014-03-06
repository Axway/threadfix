<%@ include file="/common/taglibs.jsp"%>

<head>
	<title>Remote Providers</title>
	<script type="text/javascript" src="<%=request.getContextPath()%>/scripts/remote-providers-controller.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/scripts/remote-provider-modal-controller.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/scripts/modalControllerWithConfig.js"></script>
</head>

<spring:url value="" var="emptyUrl"/>
<body ng-controller="RemoteProvidersController" ng-init="csrfToken = '<c:out value="${ emptyUrl }"/>'">
	<h2>Remote Providers</h2>

    <%@ include file="/WEB-INF/views/config/remoteproviders/configure.jsp" %>
    <%@ include file="/WEB-INF/views/config/remoteproviders/editMapping.jsp" %>

    <div id="helpText">
		Remote Providers are links to services which
		import vulnerability data into ThreadFix.
	</div>

    <div ng-hide="initialized" class="spinner-div"><span class="spinner dark"></span>Loading</div><br>

    <div ng-show="initialized" id="headerDiv">
		<table class="table table-striped">
            <thead>
            <tr>
                <th class="medium first">Name</th>
                <th class="medium">User name</th>
                <c:if test="${ not canManageRemoteProviders }">
                    <th class="medium last">API Key</th>
                </c:if>
                <c:if test="${ canManageRemoteProviders }">
                    <th class="medium">API Key</th>
                    <th class="medium last">Configure</th>
                </c:if>
            </tr>
            </thead>
            <tbody id="remoteProvidersTableBody">
                <tr ng-show="providers.length === 0" class="bodyRow">
                    <td colspan="4" style="text-align:center;"> No providers found.</td>
                </tr>
                <tr ng-repeat="provider in providers" class="bodyRow">
                    <td id="name{{ $index }}">
                        {{ provider.name }}
                    </td>
                    <td id="username{{ $index }}">
                        {{ provider.username }}
                    </td>
                    <td id="apiKey{{ $index }}">
                        {{ provider.apiKey }}
                    </td>
                    <c:if test="${ canManageRemoteProviders }">
                        <td>
                            <a id="configure{{ $index }}" class="btn" ng-click="configure(provider)">Configure</a>
                        </td>
                    </c:if>
                </tr>
            </tbody>
        </table>

    </div>
	

    <div ng-repeat="provider in providers">

        <div ng-show="provider.successMessage" class="alert alert-success">
            <button class="close" ng-click="provider.successMessage = undefined" type="button">&times;</button>
            {{ provider.successMessage }}
        </div>

        <h2 ng-show="provider.remoteProviderApplications" style="padding-top:15px">
            {{ provider.name }} Applications

            <a class="btn header-button" id="updateApps{{ provider.id }}" style="font-size:60%;padding-left:10px;padding-right:8px;" ng-click="updateApplications(provider)">
                Update Applications
            </a>

            <c:if test="${ remoteProvider.hasConfiguredApplications }">
                <a class="btn header-button" id="updateApps{{ provider.id }}"
                   style="font-size:60%;padding-left:10px;padding-right:8px;"
                   ng-click="importAllScans(provider)">
                    Import All Scans
                </a>
            </c:if>

            <c:if test="${ canManageRemoteProviders }">
                <button id="clearConfig{{ provider.id }}" ng-click="clearConfiguration(provider)" class="btn btn-primary" type="submit">Clear Configuration</button>
            </c:if>
        </h2>

        <div ng-show="provider.remoteProviderApplications" class="pagination" ng-init="provider.page = 1">
            <pagination class="no-margin"
                        total-items="provider.remoteProviderApplications.length / 10"
                        max-size="5"
                        page="provider.page"
                        ng-click="paginate(provider)"></pagination>
        </div>

        <table ng-show="provider.remoteProviderApplications" class="table table-striped" style="table-layout:fixed;">
            <thead>
                <tr>
                    <th class="medium first">Name / ID</th>
                    <th class="medium">Team</th>
                    <th class="medium">Application</th>
                    <c:if test="${ canManageRemoteProviders }">
                        <th class="medium">Edit</th>
                    </c:if>
                    <th class="medium last">Import Scan</th>
                </tr>
            </thead>
            <tbody>

                <tr ng-repeat="app in provider.displayApps">
                    <td id="provider{{ provider.id }}appid{{ app.id }}">
                        {{ app.nativeId }}
                    </td>
                    <td id="provider{{ provider.id }}tfteamname{{ $index }}">
                        <div ng-show="app.application" style="word-wrap: break-word;max-width:170px;text-align:left;">
                            <a ng-click="goToTeam(app.application.organization)">
                                {{ app.application.team.name }}
                            </a>
                        </div>
                    </td>
                    <td id="provider{{ provider.id }}tfappname{{ $index }}">
                        <div ng-show="app.application" style="word-wrap: break-word;max-width:170px;text-align:left;">
                            <a ng-click="goToApp(app.application)">
                                {{ app.application.name }}
                            </a>
                        </div>
                    </td>
                    <c:if test="${ canManageRemoteProviders }">
                        <td>
                            <a id="provider{{ provider.id }}updateMapping{{ $index }}" class="btn" ng-click="openAppModal(provider, app)">Edit Mapping</a>
                        </td>
                    </c:if>
                    <td>
                        <a ng-show="app.application" class="btn" id="provider{{ provider.id }}import{{ $index }}" ng-click="importScansApp(provider, app)">Import</a>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

</body>
