/* angular-mock-promise 0.1.1 */

(function() {
  angular.module('angular-mock-promise', []).factory('promiseExpectation', [
    '$rootScope', function($rootScope) {
      var promiseExpectation;
      promiseExpectation = (function() {
        function promiseExpectation(promise) {
          var _this = this;
          this.resolveFn = jasmine.createSpy('promise resolved').andCallFake(function() {
            _this.resolveFnCalled = true;
            _this.args = arguments;
            return _this.arg = arguments[0];
          });
          this.rejectFn = jasmine.createSpy('promise rejected').andCallFake(function() {
            _this.rejectFnCalled = true;
            _this.args = arguments;
            return _this.arg = arguments[0];
          });
          promise.then(this.resolveFn, this.rejectFn);
        }

        promiseExpectation.prototype.expectToBeResolved = function() {
          expect(this.resolveFn).toHaveBeenCalled();
          return expect(this.rejectFn).not.toHaveBeenCalled();
        };

        promiseExpectation.prototype.expectToBeRejected = function() {
          expect(this.rejectFn).toHaveBeenCalled();
          return expect(this.resolveFn).not.toHaveBeenCalled();
        };

        return promiseExpectation;

      })();
      return function(promise) {
        return new promiseExpectation(promise);
      };
    }
  ]).factory('createMockPromise', [
    '$rootScope', '$q', function($rootScope, $q) {
      return function() {
        var deferred, promise;
        deferred = $q.defer();
        promise = deferred.promise;
        promise.resolve = function() {
          deferred.resolve.apply(void 0, arguments);
          return $rootScope.$apply();
        };
        promise.reject = function() {
          deferred.reject.apply(void 0, arguments);
          return $rootScope.$apply();
        };
        return promise;
      };
    }
  ]);

}).call(this);
