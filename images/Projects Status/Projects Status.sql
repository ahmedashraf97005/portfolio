-- CTE to combine completed and upcoming projects into one unified table with a Status column
;with Projects_Table as(
    select 
        project_id,
        project_name,
        project_budget,
        'completed' as Status       -- Mark these projects as completed
    from completed_projects
    union all
    select 
        project_id,
        project_name,
        project_budget,
        'upcoming' as Status        -- Mark these projects as upcoming
    from [upcoming projects]
),

-- CTE to associate projects with employees assigned to them
full_Projects_Table as(
    select 
        ps.employee_id,
        pt.project_id,
        pt.project_name,
        pt.project_budget,
        pt.Status
    from Projects_Table pt
    right join project_assignments ps
    on pt.project_id = ps.project_id
),

-- CTE to add employee head shots to the full projects and assignments table
full_Projects_Table_heads as(
    select 
        fpt.employee_id,
        fpt.project_id,
        fpt.project_name,
        fpt.project_budget,
        fpt.Status,
        hs.Head_Shot                   -- Employee's head shot image or link
    from full_Projects_Table fpt
    right join Head_Shots hs
    on fpt.employee_id = hs.employee_id
)

-- Final select: 
-- Retrieve employee details, department info, and their project assignments including project status and budget, plus head shot
select
    e.employee_id,
    e.first_name,
    e.last_name,
    e.job_title,
    e.salary,
    d.Department_ID,
    d.Department_Name,
    d.Department_Goals,
    d.Department_Budget,
    fpts.project_id,
    fpts.project_name,
    fpts.Status,
    fpts.project_budget,
    fpts.Head_Shot
from employees e
left join departments d
    on e.department_id = d.Department_ID
left join full_Projects_Table_heads fpts
    on fpts.employee_id = e.employee_id
