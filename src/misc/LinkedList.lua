---
-- linked list implementation
--
-- Copyright (c) Wopster, 2018

LinkedList = {}

local LinkedList_mt = Class(LinkedList)

function LinkedList:new()
    local instance = {}

    setmetatable(instance, LinkedList_mt)

    instance.head = nil
    instance.tail = nil
    instance.size = 0

    return instance
end

---
-- Inserts the specified value at the beginning of the list
-- @param self
-- @param value
--
local function _linkFirst(self, value)
    local t = self.head
    local node = LinkedNode:new(nil, t, value)

    self.head = node
    if t == nil then
        self.tail = node
    else
        t._prev = node
    end

    self.size = self.size + 1
end

---
-- Inserts the specified value at the end of the list
-- @param self
-- @param value
--
local function _linkLast(self, value)
    local t = self.tail
    local node = LinkedNode:new(t, nil, value)

    self.tail = node
    if t == nil then
        self.head = node
    else
        t._next = node
    end

    self.size = self.size + 1
end

---
-- Inserts value before LinkedNode succ
-- @param self
-- @param value
-- @param succ
--
local function _linkBefore(self, value, succ)
    local prev = succ._prev
    local node = LinkedNode:new(prev, succ, value)

    succ._prev = node

    if prev == nil then
        self.first = node
    else
        prev._next = node
    end

    self.size = self.size + 1
end

---
-- Adds value to the beginning of the list
-- @param value
--
function LinkedList:addFirst(value)
    _linkFirst(self, value)
    return true
end

---
-- Adds value to the end of the list
-- @param value
--
function LinkedList:add(value)
    _linkLast(self, value)
    return true
end

---
-- Removes value from the beginning of the list
function LinkedList:removeFirst()
    local t = self.tail

    local item = t._item
    local next = t._next

    -- Help GC
    self.tail._item = nil
    self.tail._next = nil

    self.head = next
    if self.head then
        next._prev = nil
    else
        self.tail = nil
    end

    self.size = self.size - 1

    return item
end

---
-- Adds value on the given index
-- @param index
-- @param value
--
function LinkedList:insert(index, value)
    if index == self.size then
        _linkLast(self, value)
    else
        _linkBefore(self, value, self:_node(index))
    end
end

---
-- Deletes node with the giving index
-- @param index
--
function LinkedList:delete(index)
    local node = self:_node(index)

    local next = node._next
    local prev = node._prev

    if prev == nil then
        self.head = next
    else
        prev._next = next
        node._prev = nil
    end

    if next == nil then
        self.tail = prev
    else
        next._prev = prev
        node._next = nil
    end

    local item = node._item
    node._item = nil

    self.size = self.size - 1

    return item
end

---
-- Gets value from the list
-- @param index
--
function LinkedList:get(index)
    return self:_node(index)._item
end

function LinkedList:getSize()
    return self.size
end

local function bitShiftLeft(x, by)
    return x * 2 ^ by
end

local function bitShiftRight(x, by)
    return math.floor(x / 2 ^ by)
end

function LinkedList:_node(index)
    if index < bitShiftRight(self.size, 1) then
        local x = self.head
        for i = 0, index do
            if not i < index then break end
            x = x._next
        end

        return x
    end

    local x = self.tail
    for i = self.size - 1, 1, -1 do
        if not i > index then break end
        x = x._prev
    end

    return x
end

local function iterateNext(self, current)
    if not current then
        current = self.head
    elseif current then
        current = current._next
    end

    return current
end

local function iteratePrev(self, current)
    if not current then
        current = self.tail
    elseif current then
        current = current._prev
    end

    return current
end

function LinkedList:iterate()
    return iterateNext, self, nil
end

function LinkedList:iterateDesc()
    return iteratePrev, self, nil
end

LinkedNode = {}

local LinkedNode_mt = Class(LinkedNode)

function LinkedNode:new(prev, next, item)
    local instance = {}
    setmetatable(instance, LinkedNode_mt)

    instance._prev = prev
    instance._next = next
    instance._item = item

    return instance
end
