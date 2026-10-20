<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<sql:transaction dataSource="${db}">
<sql:query var="resumenPanel">
SELECT (SELECT count(*) FROM parcial_joan_carlos.anteproyectos) AS anteproyectos,
       (SELECT count(*) FROM parcial_joan_carlos.ideas WHERE estado='DISPONIBLE') AS ideas,
       (SELECT count(*) FROM parcial_joan_carlos.revisiones) AS revisiones,
       (SELECT count(*) FROM parcial_joan_carlos.practicas) AS practicas
</sql:query>
<sql:query var="expedientesRecientes">
SELECT p.codigo,p.titulo,p.estado,p.modalidad,u.nombre AS estudiante
FROM parcial_joan_carlos.anteproyectos p
JOIN parcial_joan_carlos.usuarios u ON u.id=p.estudiante_id
WHERE CAST(? AS TEXT) IN ('ADMINISTRADOR','COORDINACION')
   OR p.estudiante_id=CAST(? AS BIGINT) OR p.director_id=CAST(? AS BIGINT) OR p.evaluador_id=CAST(? AS BIGINT)
ORDER BY p.actualizado_en DESC, p.id DESC LIMIT 5
<sql:param value="${sessionScope.rol}"/><sql:param value="${sessionScope.idUsuario}"/>
<sql:param value="${sessionScope.idUsuario}"/><sql:param value="${sessionScope.idUsuario}"/>
</sql:query>
</sql:transaction>
<c:set var="titulo" value="Panel académico"/>
<c:set var="subtitulo" value="Seguimiento de anteproyectos, responsables y entregas del periodo académico."/>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>
<section class="welcome-banner" aria-label="Bienvenida">
 <div class="welcome-copy"><span class="eyebrow">GESTIÓN ACADÉMICA · 2026-2</span>
 <h2>Bienvenido al portal de trabajos de grado</h2>
 <p>Consulta avances, revisa entregas y encuentra rápidamente lo que necesitas para continuar tu proceso académico.</p>
 <div class="welcome-actions"><c:choose><c:when test="${sessionScope.rol eq 'ADMINISTRADOR'}"><a class="btn primary" href="<c:url value='/usuarios.jsp'/>">Gestionar usuarios <span aria-hidden="true">↗</span></a></c:when><c:otherwise><a class="btn primary" href="<c:url value='/proyectos.jsp'/>">Consultar expedientes <span aria-hidden="true">↗</span></a></c:otherwise></c:choose><a class="btn secondary" href="<c:url value='/calendario.jsp'/>">Calendario académico</a></div>
 </div><div class="welcome-emblem" aria-hidden="true"><span>UTS</span><small>GESTIÓN DE GRADO</small></div>
</section>
<div class="section-heading"><div><span class="eyebrow accent">PANORAMA DEL PROCESO</span><h2>Resumen académico</h2></div><span class="summary-tag">Periodo 2026-2</span></div>
<section class="metric-grid" aria-label="Indicadores del proceso">
 <div class="metric"><span class="metric-symbol" aria-hidden="true">▤</span><span class="metric-label">Anteproyectos</span><strong><c:out value="${resumenPanel.rows[0].anteproyectos}"/></strong><small>Registrados en el sistema</small></div>
 <div class="metric"><span class="metric-symbol" aria-hidden="true">◇</span><span class="metric-label">Ideas disponibles</span><strong><c:out value="${resumenPanel.rows[0].ideas}"/></strong><small>Banco de propuestas</small></div>
 <div class="metric"><span class="metric-symbol" aria-hidden="true">✓</span><span class="metric-label">Revisiones</span><strong><c:out value="${resumenPanel.rows[0].revisiones}"/></strong><small>Conceptos registrados</small></div>
 <div class="metric"><span class="metric-symbol" aria-hidden="true">▦</span><span class="metric-label">Prácticas</span><strong><c:out value="${resumenPanel.rows[0].practicas}"/></strong><small>Procesos formativos</small></div>
</section>
<div class="dashboard-columns"><section class="panel recent-panel">
<div class="section-heading compact"><div><span class="eyebrow accent">SEGUIMIENTO</span><h2>Expedientes recientes</h2></div><c:if test="${sessionScope.rol ne 'ADMINISTRADOR'}"><a class="text-link" href="<c:url value='/proyectos.jsp'/>">Ver todos ↗</a></c:if></div>
<div class="table-scroll"><table class="recent-table"><thead><tr><th>Código</th><th>Proyecto</th><th>Estado</th></tr></thead><tbody>
<c:forEach items="${expedientesRecientes.rows}" var="p"><tr><td><strong><c:out value="${p.codigo}"/></strong></td><td><div class="project-name"><c:out value="${p.titulo}"/></div><span class="row-muted"><c:out value="${p.estudiante}"/></span></td><td><span class="status-chip"><c:choose><c:when test="${p.estado eq 'PENDIENTE_DIRECTOR'}">Revisión del director</c:when><c:when test="${p.estado eq 'PENDIENTE_EVALUADOR'}">En evaluación</c:when><c:when test="${p.estado eq 'APROBADO'}">Aprobado</c:when><c:when test="${p.estado eq 'BORRADOR'}">Borrador</c:when><c:when test="${p.estado eq 'DEVUELTO'}">Con correcciones</c:when><c:otherwise><c:out value="${p.estado}"/></c:otherwise></c:choose></span></td></tr></c:forEach>
<c:if test="${empty expedientesRecientes.rows}"><tr><td colspan="3" class="empty-table">Todavía no hay expedientes asignados a tu perfil.</td></tr></c:if>
</tbody></table></div>
<p class="demo-footnote">Los expedientes iniciales se utilizan para comprobar el funcionamiento del portal.</p>
</section>
<section class="panel quick-panel"><div class="section-heading compact"><div><span class="eyebrow accent">ACCESOS DIRECTOS</span><h2>Gestiones frecuentes</h2></div></div>
<div class="quick-links">
<c:if test="${sessionScope.rol eq 'ADMINISTRADOR'}"><a href="<c:url value='/usuarios.jsp'/>"><span class="quick-icon">♧</span><span><strong>Usuarios y roles</strong><small>Gestionar cuentas del sistema</small></span><b>↗</b></a><a href="<c:url value='/auditoria.jsp'/>"><span class="quick-icon">◷</span><span><strong>Historial de auditoría</strong><small>Consultar operaciones registradas</small></span><b>↗</b></a></c:if>
<c:if test="${sessionScope.rol eq 'COORDINACION'}"><a href="<c:url value='/ideas.jsp'/>"><span class="quick-icon">◇</span><span><strong>Banco de ideas</strong><small>Administrar propuestas</small></span><b>↗</b></a><a href="<c:url value='/asignaciones.jsp'/>"><span class="quick-icon">♧</span><span><strong>Asignar responsables</strong><small>Director y evaluador</small></span><b>↗</b></a></c:if>
<c:if test="${sessionScope.rol eq 'ESTUDIANTE'}"><a href="<c:url value='/anteproyectos.jsp'/>"><span class="quick-icon">▤</span><span><strong>Mis anteproyectos</strong><small>Gestionar entregas</small></span><b>↗</b></a><a href="<c:url value='/ideas.jsp'/>"><span class="quick-icon">◇</span><span><strong>Explorar ideas</strong><small>Consultar banco académico</small></span><b>↗</b></a></c:if>
<c:if test="${sessionScope.rol eq 'DIRECTOR' or sessionScope.rol eq 'EVALUADOR'}"><a href="<c:url value='/revisiones.jsp'/>"><span class="quick-icon">✓</span><span><strong>Revisiones pendientes</strong><small>Conceptos y calificaciones</small></span><b>↗</b></a><a href="<c:url value='/rubrica.jsp'/>"><span class="quick-icon">▦</span><span><strong>Rejilla de evaluación</strong><small>Revisar los criterios</small></span><b>↗</b></a></c:if>
<a href="<c:url value='/practicas.jsp'/>"><span class="quick-icon">▧</span><span><strong>Prácticas empresariales</strong><small>Procesos, tutorías y avances</small></span><b>↗</b></a>
<a href="<c:url value='/formatos.jsp'/>"><span class="quick-icon">▤</span><span><strong>Formatos de grado</strong><small>Documentación del proceso</small></span><b>↗</b></a>
<a href="<c:url value='/notificaciones.jsp'/>"><span class="quick-icon">◎</span><span><strong>Notificaciones</strong><small>Comunicaciones académicas</small></span><b>↗</b></a>
</div></section></div>
<%@ include file="/WEB-INF/jspf/pie.jspf" %>
