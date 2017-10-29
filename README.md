<h1 align="center">HooI</h1>

HooI is a UI library written to be used with the LÖVE 2D game engine and is currently still under development and non production ready.

The main goal of this library is to define the UI in various screens which can be layered ontop of each other. With the ability to give any element as many or as little functionality as needed without enforcing a specific design or prepackage functionality into classes.

Instead. All elements are a composition of behavior.

A quick example:

```
-- Create a new canvas and define the functionality it supports.
canvas = HooI:newCanvas("StartScreen", true, {
        "DrawableDrawSystem", 
        "HoverUpdateSystem", 
        "TooltipSystem", 
        "ClickSystem", 
        "ButtonSystem",
        "SelectableSystem"
        }
    ) 
-- Create a new widget at location (0/100) with the dimensions of (200/100)
widget = HooI:newWidget(0, 100, 200, 100)
-- Make widget clickable and define a function to be called when clicked.
widget:add(HooI.clickable(onClickedCallbackFunction))
-- Define the visual look of this button
      :add(
        HooI.button(
            love.graphics.newImage("button_normal.png"),
            love.graphics.newImage("button_hover.png"),
            love.graphics.newImage("button_click.png"),
            dx, dy, dw, dh -- Offset from the widget itself. If nil, the button visuals will be stretched to fill out the widget proportions.
        )
    )
-- Add keyboard / gamepad support to the button (defaulting to the same function as used for clickable if no callback is provided)
widget:add(HooI.selectable(widgetAbove, widgetBelow, widgetLeft, widgetRight))

canvas:add(widget)
```

The intendet usage is to split up the UI into logically linked functionality (e.g. GameOverScreen, BackgroundLayout, ObjectInfoScreen), create a canvas defined in a speparate file for each one and add / remove them as needed.

Animation of widget parameters will be added in a later release as well. 

This provides a powerful, generic interface to create complex UI functionality relatively quickly.

## Installation

The recommended way of installting HooI is by creating a submodule and cloning it right into your git repo.

To require HooI simply require the HooI folder. Assuming the HooI folder is next to your main.lua:

```
local HooI = require('HooI')
```

## API Reference

**Warning: This is the intendet API. While all functions are implemented. Some of the naming and exact behavior has to be fully implemented and / or tested**
Examples being the cursor functionality or some component variable names.

HooI consists of a few classes, created via util functions.

The following classes exist:

* Canvas - Your "screen" so to speak. They manage widgets and forward calls across canvases.
* Widget - An individual element. Such as an image or a Button.
* Tooltip - Another type of visual element. Used like a widget but without location, to be added as a tooltip to a widget.
* Animation - An simple and basic interface for creating animated elements.
* Callback - A wrapper to support custom classes / objects and stateful function calls. 
* Components - Usually not created by the user. A variety of components exist. Additional components can be created as well if desired.
* Systems - Usually not created by the user. A variety of systems exists. Additional systems can be created as well if desired. 

### Components

Components are databags. They define which systems will operate on a widget and the data used for those operations.

Documentation for creating and adding custom components will be added in the future.

All components can be initialized in two ways. With a regular parameter list or with a table defining the individual entries and what they should be set to.
Example:
```
tooltip = HooI.selectable(WidgetUp, WidgetDown, WidgetLeft, WidgetRigth)
tooltip = HooI.selectable{left=WidgetLeft, right=WidgetRight, up=WidgetUp, down=WidgetDown}
```

The following components exist:

#### HooI.hoverable(enterCallback, leaveCallback, button, layer, dx, dy, dw, dh, cursor)
- **enterCallback** (Function or Callback) - The function to be called when the cursor starts hovering the widget. Defaults to empty function.
- **leaveCallback** (Function or Callback) - The function to be called when the cursor stops hovering the widget. Defaults to empty function.
- **layer** (Number) - The layer this hoverable belongs to. Layers only exist within a canvas and help determine which element is hovered if two are above one another.
- **dx** (Number) - Offset from the widget location on the x axis.
- **dy** (Number) - Offset from the widget location on the y axis.
- **dw** (Number) - Offset from the widget width in pixels.
- **dw** (Number) - Offset from the widget height in pixels.
- **cursor** (Cursor / userdata) - The cursor to be displayed when hovering this widget. Defaults to system default hand. 

Returns a hoverable component.

#### HooI.clickable(clickCallback, layer, dx, dy, dw, dh, cursor)
- **enterCallback** (Function or Callback) - The function to be called when the cursor has pressed and released the defined mouse button. Defaults to function printing "click". 
- **layer** (Number) - The layer this hoverable belongs to. Layers only exist within a canvas and help determine which element is clicked if two are above one another.
- **button** (Number) - The mouse button to listen for.
- **dx** (Number) - Offset from the widget location on the x axis.
- **dy** (Number) - Offset from the widget location on the y axis.
- **dw** (Number) - Offset from the widget width in pixels.
- **dw** (Number) - Offset from the widget height in pixels.
- **cursor** (Cursor / userdata) - The cursor to be displayed when hovering this widget. Defaults to system default hand. 

Returns a clickable component.

**Note:** Functionality is not complete yet. Button defaults to 1 (lmb). Interface needs some work to define responses to multiple buttons.

#### HooI.selectable(up, down, left, right)
- **up** (Widget) - The widget which should be selected when "up" keyInput is provided.
- **down** (Widget) - The widget which should be selected when "down" keyInput is provided.
- **left** (Widget) - The widget which should be selected when "left" keyInput is provided.
- **right** (Widget) - The widget which should be selected when "right" keyInput is provided.

Returns a selectable component.

#### HooI.drawable(drawable, layer, dx, dy, dw, dh)
- **drawable** (Drawable or Animation) - A love2d drawable (e.g. Image) or Animation object.
- **layer** (Number) - The layer this hoverable belongs to. Layers only exist within a canvas and help determine which element is drawn in front of the other.
- **dx** (Number) - Offset from the widget location on the x axis.
- **dy** (Number) - Offset from the widget location on the y axis.
- **dw** (Number) - Offset from the widget width in pixels.
- **dw** (Number) - Offset from the widget height in pixels.

Returns a drawable component.

#### HooI.button(noramlDrawable, hoverDrawable, clickDrawable)
- **normalDrawable** (Drawable or Animation) - The drawable to be drawn in an idle state.
- **hoverDrawable** (Drawable or Animation) - The drawable to be drawn when hovered or selected.
- **clickDrawable** (Drawable or Animation) - The drawable to be drawn when clicked or executed.

Returns a button component.

**Note:** Button does not implement any click or hover functionality and depends on hoverable, clickable and selectable.
Hoverable and clickable will be added with default values if none exist. Selectable has to be added manually.

#### HooI.tooltip(widget)

- **widget** (Tooltip) - The tooltip object to be used for rendering when this widget is hovered.

Returns a tooltip component.

### Systems

Systems execute functionaltiy based on the components that have been added to a widget and are initialized upon canvas creation.
Systemnames corelate with their components and only operate on widgets with those components.

The following systems exist:

* **WidgetDrawSystem**
* **HoverUpdateSystem**
* **ClickSystem**
* **TooltipSystem**
* **DrawableDrawSystem**
* **ButtonSystem**
* **SelectableSystem**

(Names are subject to change)

Documentation for creating and adding custom systems will be added in the future.

### HooI

**Note:** HooI does not reset the graphics translation. If you have translated your screen before, it will apply to all elements. It is recommended to make sure that 0 is the origin. However. Screenshakes and similar can easily be applied to the UI like this.

#### HooI:newCanvas(name, active, systems)
- **name** (String) - The name of this canvas.
- **active** (Bool) - Whether or not this canvas is visible upon creation or not.
- **systems** (List) - A list of system names to be initialized for this canvas. Further systems can be added later on if necessary.

Returns a canvas object.

#### HooI:newWidget(x, y, w, h)
- **x** (Number) - The locaiton of the widget on the x axis on the screen.
- **y** (Number) - The location of the widget on the y axis on the screen.
- **w** (Number) - The width of the widget in pixels.
- **h** (Number) - The height of the widget in pixels.

Returns a widget object.

#### HooI:newTooltip(w, h)
- **w** (Number) - The width of the tooltip in pixels.
- **h** (Number) - The height of the tooltip in pixels.

Returns a new tooltip object.

#### HooI:newAnimation(image, quads, duration)
- **image** (Image / userdata) - A love2d image containing the spritesheet for this animation.
- **quads** (List) - A list of love2d quad objects, defining the amount of sprites and where they are located on the image.
- **duration** (Number) - The duration of the animation in seconds. Determines how fast the quad list is iterated over.

Returns a new animation object.

**Note:** All animations loop as of now!

#### HooI:newCallback(table, func)
- **table** (Table) - The first parameter passed to the function. Intendet to be self but can be any value.
- **func** (Function) - The function to be called.

Returns a new callback object.

#### HooI:update(dt)
- **dt** (Number) - The time since the last frame.

**Note:** This is a mandatory function! A lot of things will not work as expected if you do not call update every frame!

#### HooI:draw()

**Note:** This is a mandatory function! The UI will not draw if you do not call this function every frame!

#### HooI:mousePressed(x, y, button)
- **x** (Number) - The location on the x axis of the mouse when it was pressed.
- **y** (Number) - The location on the y axis of the mouse when it was pressed.
- **button** (Number) - The button used.

Returns true if the mouse press was used by any canvas.

**Note:** An alias exists. You can call either :mousePressed() or :mousepressed()
**Note:** Just forward the variables you get from love.mousepressed.

#### HooI:mouseReleased(x, y, button)
- **x** (Number) - The location on the x axis of the mouse when it was released.
- **y** (Number) - The location on the y axis of the mouse when it was released.
- **button** (Number) - The button used.

Returns true if the mouse release was used by any canvas.

**Note:** An alias exists. You can either call :mouseReleased() or :mousereleased()
**Note:** Just forward the variables you get from love.mousereleased.

#### HooI:keyInput(inputType)
- **inputType** (String) - The type of input provided.

Returns true if the key input was used by any canvas.

**Note:** HooI does not dictate which buttons cause which functionality. As such you are meant to implement the button handling yourself and forward a call if desired. The following inputTypes are supporetd by the selectable component:

* up        - Move to the next selectable above.
* down      - Move to the next selectable below.
* left      - Move to the next selectable to the right.
* right     - Move to the next selectable to the left.
* press     - Press the selected selectable.
* execute   - Execute (aka "Click") the selected selectable. 

**Sidenote:** Execute will only work, if the selected selectable has been pressed beforehand. The pressed status of a widget is removed upon selecting another selectable. With key or mouse input. 

#### HooI:activateCanvasByName(name)
- **name** (String) - The name of the canvas to be activated (making it visible and activating all events).

Returns the canvas which has been activated.

#### HooI:deactivateCanvasByName(name)
- **name** (String) - The name of the canvas to be deactivated (making it invisible and disabling all events).

Returns the canvas which has been deactivated.

### Canvas

A canvas represents your screen. Any number of canvases can be active at any time. Event calls happen from top to bottom and stop propagating when used.
In other words. If you click and forward that via the API, it will be converted into a event and each canvas will be checked, starting with the last one added. When a canvas has a clickable at that location, it will stop checking canvases below.

#### Canvas:update(dt)
- **dt** (Number) - The time since the last frame.

**Note:** Manually update a canvas. Usually called by HooI

#### Canvas:draw()

**Note:** Manually draw a canvas. Usually called by HooI

#### Canvas:mousePressed(x, y, button)
- **x** (Number) - The location on the x axis of the mouse when it was pressed.
- **y** (Number) - The location on the y axis of the mouse when it was pressed.
- **button** (Number) - The button used.

Returns true if the mouse press was used by this canvas.

**Note:** Manually call mosuePressed on a canvas. Usually called by HooI.

#### Canvas:mouseReleased(x, y, button)
- **x** (Number) - The location on the x axis of the mouse when it was released.
- **y** (Number) - The location on the y axis of the mouse when it was released.
- **button** (Number) - The button used.

Returns true if the mouse release was used by this canvas.

**Note:** Manually call mouseReleased on this canvas. Usually called by HooI.

#### Canvas:keyInput(inputType)
- **inputType** (String) - The type of input provided.

Returns true if the key input was used by this canvas.

**Note:** Manually call keyInput on this canvas. Usually called by HooI.

#### Canvas:add(newWidget)
- **newWidget** (Widget) - The widget to be added.

#### Canvas:remove(widget, removeChildren)
- **widget** (Widget) - The widget to be removed.
- **removeChildren** (Bool) - Whether children should be removed as well or not.

#### Canvas:startSystem(systemName)
- **systemName** (String) - The name of the system to be stopped.

**Note:** Adds the functionality of this previously stopped system to this canvas.


#### Canvas:stopSystem(systemName)
- **systemName** (String) - The name of the system to be stopped.

**Note:** Removes the functionality supported by that system from this canvas.

#### Canvas:toggleSystem(systemName)
- **systemName** (String) - The name of the system to be toggled.

#### Canvas:activate(index)
- **index** (Number) - The index this canvas should be put at.

**Note:** If the canvas isn't active, adds the canvas into the canvas stack at index or on top of it. 

#### Canvas:deactiavte()

**Note:** Removes the canvas from the canvas stack. No HooI calls will be forwarded. You can still manually call the functions though.

#### Canvas:activateWidget(widget)
- **widget** (Widget) - The widget to be activated. Active widgets get drawn and updated.

#### Canvas:deactivateWidget(widget)
- **widget** (Widget) - The widget to be deactivated. Inactive widgets don't get drawn or updated.

### Widget

A widget is any element of the UI. It can be pure functionality, pure visuals or both. Each widget only contains one element (aka one image or one button)

#### Widget.eventManager

This is a reference to the eventManager of the canvas this Widget has been added to.
Therefore there will be no eventManager until the Widget is added to a canvas.

#### Widget:setParent(parent)
- **parent** (Widget) - Parent Widget

Use this method to set a new parent on an Widget. It will take care of removing itself from the children of its previous parent and registering as a child of the new parent.

#### Widget:getParent()

Returns the entities parent.

#### Widget:add(component)
- **component** - (Component) Instance of a component.

Adds a component to this particular Widget.

*HooECS specific*

Returns a reference to the Widget to allow for the following syntactic suggar:

```lua
widget:add(component1)
      :add(component2)
      :add(component3)
```

#### Widget:addMultiple(components)
- **components** - (List) A list containing instances of components.

Adds multiple components to the Widget at once.

#### Widget:set(component)
- **component** - (Component) Instance of a component.

Adds the component to this particular Widget. If there already exists a component of this type the previous component will be overwritten.

#### Widget:remove(name)
- **name** (String) - Name of the component class

Removes a component from this particular Widget.

Returns a reference to the Widget to allow for the following syntactic suggar:

```lua
Widget:remove(component1)
      :remove(component2)
      :remove(component3)
```

#### Widget:has(Name)
- **name** (String) - Name of the component class

Returns boolean depending on if the component is contained by the Widget.


#### Widget:get(Name)
- **name** (String) - Name of the component class

Returns the component or `nil` if the Widget has no component with the given `name`.

#### Widget:getComponents()

Returns the list that contains all components.

#### Widget:setMultiple(components)
- **components** (List) - A list containing instances of components.

#### Widget:isActive()

Returns whether the Widget is active or not.

An inactive Widget will still be part of the engine, but it will be removed from all systems and won't be updated or drawn.
Activation will add the Widget to all appropriate systems.

#### Widget:activate()

If not already active, adds the Widget to all appropriate systems. The Widget needs to belong to an engine for this to work. 

#### Widget:deactivate()

If active, removes the Widget from all systems without removing the Widget from the engine.

#### Widget:getEngine()

Returns the engine this Widget belongs to.

#### Widget:getChildren()

Returns the children this Widget has or nil if there are none.

#### Widget:copy(componentList)

- **componentList** (List) - A table containing components

Returns a new Widget with a deep copy of all components.
This means there will be a copy of all components and all values will be the same.

If a componentList is supplied, all components contained will be set (overwrite components with the same name).

#### Widget:shallowCopy(componentList)

- **componentList** (List) - A table containing components

Returns a new Widget with a shallow copy of all components.
This means modifying the component of one of the two entities will cause modifications to both.

If a componentList is supplied, all components contained will be set (overwrite components with the same name).

#### Widget:update(dt)

Overwrite this function to get an update callback before any system is updated. Useful for modifying component data before system processing.
This function has to be set before the Widget is added to the engine. Otherwise use Widget:setUpdate() instead.

#### Widget:setUpdate(newUpdateFunction)

- **newUpdateFunction** (Function) - The new function that should be called on update.

Provide an update function to the Widget and add it to the engine Widget update list if already added to an engine.
If called without parameter, the current update function is removed and the Widget is removed from the engine Widget update list.

### Tooltip

Tooltips are used exactly the same way as widgets. For obvious reasons they will never get hovered or clicked. And I would strongly discourage making it selectable, though in theory that's possible. 

### Animation

Animations don't have a more elaborate API. They are a middleclass class. As such they contain all the middleclass functions and keys.
As well as the animation specific keys:

#### Animation.image

The image of this animation.

#### Animation.quads

The quads of this animation.

#### Animation.duration

The duration of this animation.

#### Animation.currentTime

The counter variable for this animation. Will be any value between 0 and Animation.duration.

### Callback

Callbacks don't have a more elaborate API. To call the function with table as first parameter, simply call the table.

```
callback = HooI:newCallback(table, func)
callback()
```

#### Callback.table

The table provided on creation.

#### Callback.func

The function provided on creation.