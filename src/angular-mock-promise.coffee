angular.module('angular-mock-promise', [])

  .factory('promiseExpectation', ['$rootScope', ($rootScope) ->
    class promiseExpectation
      constructor: (promise) ->
        @resolveFn = jasmine.createSpy('promise resolved').and.callFake =>
          @resolveFnCalled = true
          @args = arguments
          @arg = arguments[0]

        @rejectFn = jasmine.createSpy('promise rejected').and.callFake =>
          @rejectFnCalled = true
          @args = arguments
          @arg = arguments[0]

        promise.then @resolveFn, @rejectFn

      expectToBeUnresolved: ->
        expect(@resolveFn).not.toHaveBeenCalled()
        expect(@rejectFn).not.toHaveBeenCalled()

      expectToBeResolved: ->
        expect(@resolveFn).toHaveBeenCalled()
        expect(@rejectFn).not.toHaveBeenCalled()

      expectToBeRejected: ->
        expect(@rejectFn).toHaveBeenCalled()
        expect(@resolveFn).not.toHaveBeenCalled()


    return (promise) ->
      new promiseExpectation(promise)
  ])

  .factory('createMockPromise', ['$rootScope', '$q', ($rootScope, $q) ->
    return ->
      deferred = $q.defer()
      promise = deferred.promise

      promise.resolve = ->
        deferred.resolve.apply(undefined, arguments)
        $rootScope.$apply()

      promise.reject = ->
        deferred.reject.apply(undefined, arguments)
        $rootScope.$apply()

      return promise
  ])
