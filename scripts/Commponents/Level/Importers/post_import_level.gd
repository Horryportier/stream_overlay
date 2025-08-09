@tool
extends Node


func post_import(level: LDTKLevel) -> LDTKLevel:
    var x  = level.size.x as float
    var y  = level.size.y as float
    level.add_to_group("nav", true)
    var level_owner = level
    level.y_sort_enabled = true
    var nav_region: NavigationRegion2D = NavigationRegion2D.new()
    nav_region.name = "Nav"
    nav_region.owner = level_owner
    var nav_polygon:  = NavigationPolygon.new()
    nav_polygon.sample_partition_type = NavigationPolygon.SAMPLE_PARTITION_CONVEX_PARTITION
    nav_polygon.source_geometry_mode = NavigationPolygon.SOURCE_GEOMETRY_GROUPS_WITH_CHILDREN
    nav_polygon.source_geometry_group_name = "nav"
    nav_polygon.agent_radius = 4
    var polygon: PackedVector2Array = [Vector2.ZERO, Vector2(x , 0), Vector2(x,y ), Vector2(0, y )]
    nav_polygon.add_outline(polygon)
    nav_region.navigation_polygon = nav_polygon
    level.add_child(nav_region)
    return level
